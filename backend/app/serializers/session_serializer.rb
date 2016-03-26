class SessionSerializer < ApplicationSerializer
  attributes :id,
             :base_url,
             :notification_channel,
             :facebook_app_id,
             :discourse_url,
             :discourse_enabled

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

  def discourse_url
    Flaredown.config.discourse_url
  end

  def discourse_enabled
    Flaredown.config.discourse_enabled?
  end
end
