class Api::V1::AwsSesController < ApplicationController
  skip_authorize_resource only: [:mail_it, :notification]
  skip_before_action :authenticate_user!, only: [:mail_it, :notification]

  def notification
    message_type = request.headers["x-amz-sns-message-type"]
    # sns_topic = request.headers['x-amz-sns-topic-arn']
    raw_post = request.raw_post

    if message_type.include? "Confirmation"
      send_subscription_confirmation(raw_post)
    elsif message_type.include? "Notification"
      EmailRejectDispatcher.perform_async(raw_post)
    end

    render nothing: true, status: 200
  end

  def send_subscription_confirmation(raw_post)
    json = JSON.parse(raw_post)

    open(json["SubscribeURL"])
  end
end
