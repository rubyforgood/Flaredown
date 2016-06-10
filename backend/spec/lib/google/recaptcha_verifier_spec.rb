require 'rails_helper'

RSpec.describe Google::RecaptchaVerifier, :vcr do

  subject { Google::RecaptchaVerifier.exec(recaptcha_response) }

  context 'given a non-expired ReCaptcha response' do
    let(:recaptcha_response) { 'non-expired-recaptcha-response-dummy-string' }
    it 'returns true' do
      is_expected.to be true
    end
  end

  context 'given an expired ReCaptcha response' do
    let(:recaptcha_response) { 'expired-recaptcha-response-dummy-string' }
    it 'returns false' do
      is_expected.to be false
    end
  end

end
