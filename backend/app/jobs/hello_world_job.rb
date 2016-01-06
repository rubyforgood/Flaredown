class HelloWorldJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.debug("Hello World".green)
  end
end
