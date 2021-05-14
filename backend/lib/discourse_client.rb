require "openssl"

class DiscourseClient
  def initialize(user, params = {})
    @user = user
    @params = params
  end

  def generate_url
    uri = URI(ENV.fetch("DISCOURSE_AUTH_URL"))

    if OpenSSL::HMAC.hexdigest("sha256", ENV.fetch("DISCOURSE_SECRET"), sso) == sig
      nonce = Base64.decode64(sso)
      sso = Base64.encode64(nonce + "&email=" + @user.email + "&external_id=" + @user.external_id)
      sig = OpenSSL::HMAC.hexdigest("sha256", ENV.fetch("DISCOURSE_SECRET"), sso)
      uri.query = {sso: sso, sig: sig}.to_query
    end

    uri.to_s
  end

  private

  def sig
    @params.fetch(:sig)
  end

  def sso
    @params.fetch(:sso)
  end
end
