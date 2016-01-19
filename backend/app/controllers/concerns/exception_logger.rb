module ExceptionLogger
  extend ActiveSupport::Concern

  included do
  end

  protected

  def log_exception(exception)
    application_trace = ActionDispatch::ExceptionWrapper.new(env, exception).application_trace
    application_trace.map! { |t| "  #{t}\n" }
    Rails.logger.error "\n#{exception.class.name} (#{exception.message}):\n#{application_trace.join}"
  end
end
