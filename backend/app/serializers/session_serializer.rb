class SessionSerializer < ApplicationSerializer
  attributes :id,
             :user_id,
             :email,
             :token,
             :settings


  def id
    1
  end

  def user_id
    object.try :id
  end

  def email
    object.try :email
  end

  def token
    object.try :authentication_token
  end

  def settings
    {
      base_url: ENV['BASE_URL'],
      notification_channel: object.try(:notification_channel),
      facebook_app_id: ENV['FACEBOOK_APP_ID'],
      discourse_url: Flaredown.config.discourse_url,
      discourse_enabled: Flaredown.config.discourse_enabled?
    }
  end

end
