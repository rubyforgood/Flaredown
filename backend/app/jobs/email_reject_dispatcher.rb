class EmailRejectDispatcher
  include Sidekiq::Worker

  def perform(raw_post)
    body = JSON.parse(raw_post)
    test_case_type = body["notificationType"]
    message_raw = body["Message"]

    recipients =
      if test_case_type == "Bounce"
        emails = body.dig("mail", "destination") || []

        {bounce: emails}
      elsif message_raw
        generate_recipients(message_raw)
      end

    return unless recipients.present?

    EmailRejectJob.perform_async(recipients)
  end

  def generate_recipients(message_raw)
    message = JSON.parse message_raw

    emails = message.dig("mail", "destination") || []
    rejected_type = message["notificationType"].downcase

    {rejected_type.to_sym => emails}
  end
end
