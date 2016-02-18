module ResponseHelpers
  extend ActiveSupport::Concern

  def response_body
    @response_body ||= ActiveSupport::HashWithIndifferentAccess.new(
      (begin
         JSON.parse(response.body, symbolize_names: true)
       rescue
         {}
       end)
    )
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :controller
end
