require 'httparty'

class SendyService
  attr_accessor :api_key, :email, :name, :signup_at, :last_checkin_at

  # Default API endpoints
  BASE_URL = ENV['SENDI_INSTALLATION']
  LIST_ID = ENV['SENDI_LIST_ID']

  def initialize(options)
    @api_key = ENV['SENDI_API_KEY']
    @email = options[:email]
    @name = options[:name]
    @signup_at = options[:signup_at]
    @last_checkin_at = options[:last_checkin_at]
  end

  def send_data
    post('subscribe', name: name,
                      email: email,
                      signup_at: signup_at,
                      last_checkin_at: last_checkin_at,
                      boolean: true, api_key: api_key, list: LIST_ID)
  end

  def get(path)
    execute :get, path, nil
  end

  def post(path, data = nil)
    execute :post, path, data
  end

  def execute(method, path, data = nil)
    response = request(method, path, data)

    case response.code
    when 200..299
      response
    when 401
      raise AuthenticationFailed, response["message"]
    when 404
      raise NotFoundError, response
    else
      raise RequestError, response
    end
  end

  def request(method, path, data = nil)
    headers = {}
    headers['content-type'] = "application/x-www-form-urlencoded"

    HTTParty.send(method, BASE_URL + path, headers: headers, body: data)
  end
end
