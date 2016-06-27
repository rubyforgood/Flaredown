module Google
  class RecaptchaVerifier

    def initialize
      @secret = ENV['RECAPTCHA_SECRET_KEY']
      @url = 'https://www.google.com/recaptcha/api/siteverify'
    end

    def self.exec(response, remoteip=nil)
      self.new.invoke_service(response, remoteip)
    end

    def invoke_service(response, remoteip)
      params = {
        secret: @secret,
        response: response,
        remoteip: remoteip
      }
      response = connection.post @url, params
      if response.status.eql?(200)
        response_json = JSON.parse(response.body)
        return response_json['success']
      else
        fail StandardError.new("#{self.class}##{__method__} Got HTTP #{response.status}")
      end
    end

    def connection
      Faraday.new(headers: { 'Accept' => 'application/json' })
    end

  end
end
