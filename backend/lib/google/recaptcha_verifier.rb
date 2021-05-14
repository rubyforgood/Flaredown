module Google
  class RecaptchaVerifier
    def initialize
      @secret = ENV["RECAPTCHA_SECRET_KEY"]
      @url = "https://www.google.com/recaptcha/api/siteverify"
    end

    def self.exec(response, remoteip = nil)
      new.invoke_service(response, remoteip)
    end

    def invoke_service(response, remoteip)
      params = {
        secret: @secret,
        response: response,
        remoteip: remoteip
      }
      response = connection.post @url, params

      return JSON.parse(response.body)["success"] if response.status.eql?(200)

      # FIXME
      # rubocop:disable Style/SignalException
      fail StandardError, "#{self.class}##{__method__} Got HTTP #{response.status}"
      # rubocop:enable Style/SignalException
    end

    def connection
      Faraday.new(headers: {"Accept" => "application/json"})
    end
  end
end
