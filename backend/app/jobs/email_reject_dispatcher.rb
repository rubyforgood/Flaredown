class EmailRejectDispatcher
  include Sidekiq::Worker

  def perform(raw_post)
    body = JSON.parse(raw_post)
    type = body['notificationType']
    message_raw = body['Message']

    recipients =
      if type == 'Bounce'
        emails = body.dig('mail', 'destination') || []

        { bounced: emails }
      elsif message_raw
        message = JSON.parse message_raw
        emails = message['notificationType'] == 'Complaint' ? message.dig('mail', 'destination') : []

        { complaint: emails }
      end

    EmailRejectJob.perform_async(recipients)
  end
end
