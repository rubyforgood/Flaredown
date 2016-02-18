class Api::BaseController < ApplicationController
  include ExceptionLogger

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: ['Resource Not Found'] }, status: 404
  end

  rescue_from ActionController::UnknownFormat do
    render json: { errors: ['Format not supported'] }, status: 406
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
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
