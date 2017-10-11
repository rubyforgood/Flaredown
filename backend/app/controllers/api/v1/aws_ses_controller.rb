class Api::V1::AwsSesController < ApplicationController
  skip_authorize_resource only: [:mail_it, :notification]
  skip_before_action :authenticate_user!, only: [:mail_it, :notification]

  NOTIFICATION_ATTRS = %w(checkin_reminder notify_top_posts notify)

  def notification
    message_type = request.headers['x-amz-sns-message-type']
    sns_topic = request.headers['x-amz-sns-topic-arn']
    raw_post = request.raw_post

    if message_type.include? 'Confirmation'
      send_subscription_confirmation(raw_post)
    elsif message_type.include? 'Notification'
      unsubscribe_recipients(raw_post)
    end

    render nothing: true, status: 200
  end

  def send_subscription_confirmation(raw_post)
    json = JSON.parse(raw_post)
    subscribe_url = json['SubscribeURL']

    open(subscribe_url)
  end

  def unsubscribe_recipients(raw_post)
    body = raw_post = JSON.parse(raw_post)
    type = body['notificationType']
    message_raw = body['Message']

    recipients =
      if type === 'Bounce'
        body.dig('mail', 'destination') || []
      elsif message_raw
       message = JSON.parse message_raw
       message['notificationType'] === 'Complaint' ? message.dig('mail', 'destination') : []
      end

    recipients.map do |email|
      unsubscribe_from_all(email)
    end
  end

  def unsubscribe_from_all(recipients)
    update_hash = NOTIFICATION_ATTRS.reduce({}) { |h, v| h[v] = false; h }

    User.where(email: recipients).includes(:profile).map do |user|
      user.profile.update_attributes(update_hash)
    end
  end
end
