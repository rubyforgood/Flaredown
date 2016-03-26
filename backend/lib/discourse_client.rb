class DiscourseClient
  def initialize(user, params = {})
    @user, @params = user, params
  end

  def to_url
    @user.to_json
  end

end
