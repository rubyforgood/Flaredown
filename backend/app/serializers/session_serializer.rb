class SessionSerializer < ApplicationSerializer
  attributes  :id,
              :base_url,
              :notification_channel,
              :facebook_app_id

  def id
    1
  end

  def facebook_app_id
    ENV['FACEBOOK_APP_ID']
  end

  def base_url
    ENV['BASE_URL']
  end

  def notification_channel
    current_user.try :notification_channel
  end

end
