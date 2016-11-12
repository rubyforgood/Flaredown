module ExceptionLogger
  extend ActiveSupport::Concern

  included do
    # keep this on top
    if Rails.env.production?
      rescue_from Exception do |exception|
        Airbrake.notify(exception)
        render json: { errors: exception.message }, status: :unprocessable_entity
      end
    end

    rescue_from ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound do
      render json: { errors: ['Resource Not Found'] }, status: 404
    end

    rescue_from ActionController::UnknownFormat do
      render json: { errors: ['Format not supported'] }, status: 406
    end

    rescue_from ActiveRecord::RecordInvalid, Mongoid::Errors::Validations do |exception|
      log_exception(exception)
      render json: { errors: exception.record.errors }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |exception|
      render json: { errors: ["Required parameter missing: #{exception.param}"] }, status: :unprocessable_entity
    end

    rescue_from ActionController::BadRequest do |exception|
      render json: { errors: ["Bad request: #{exception.message}"] }, status: :bad_request
    end

    rescue_from CanCan::AccessDenied do |exception|
      log_exception(exception)
      render json: { errors: ['Unauthorized'] }, status: :unauthorized
    end
  end

  protected

  def log_exception(exception)
    application_trace = ActionDispatch::ExceptionWrapper.new(env, exception).application_trace
    application_trace.map! { |t| "  #{t}\n" }
    Rails.logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
  end
end
