RSpec.configure do |config|
  config.before(:each, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  config.include Devise::TestHelpers, type: :controller
end
