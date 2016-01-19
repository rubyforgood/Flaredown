class SessionSerializer < ApplicationSerializer
  attributes  :id,
              :base_url,
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

end
