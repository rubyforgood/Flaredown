require "rails_helper"

RSpec.describe Registration do
  subject { Registration.create!(params) }

  let(:params) do
    ActionController::Parameters.new(
      registration: {
        email: "user@example.com",
        password: "secret123",
        password_confirmation: "secret123",
        screen_name: "user",
        captcha_response: "dummy-captcha-response"
      }
    )
  end

  before { allow(Google::RecaptchaVerifier).to receive(:exec).and_return(true) }

  context "with blank screen_name" do
    before { params[:registration][:screen_name] = "" }
    it "raises record invalid exception with proper error" do
      expect { subject }.to raise_error do |e|
        expect(e).to be_a(ActiveRecord::RecordInvalid)
        expect(e.record.errors[:screen_name]).to eq ["can't be blank"]
      end
    end
  end

  context "with blank captcha_response" do
    before { params[:registration][:captcha_response] = "" }
    it "raises record invalid exception with proper error" do
      expect { subject }.to raise_error do |e|
        expect(e).to be_a(ActiveRecord::RecordInvalid)
        expect(e.record.errors[:captcha_response]).to eq ["can't be blank"]
      end
    end
  end

  context "with invalid captcha_response" do
    before { allow(Google::RecaptchaVerifier).to receive(:exec).and_return(false) }
    it "raises record invalid exception with proper error" do
      expect { subject }.to raise_error do |e|
        expect(e).to be_a(ActiveRecord::RecordInvalid)
        expect(e.record.errors[:captcha_response]).to eq ["verification failed or response expired"]
      end
    end
  end

  context "with blank email" do
    before { params[:registration][:email] = "" }
    it "raises record invalid exception with proper error" do
      expect { subject }.to raise_error do |e|
        expect(e).to be_a(ActiveRecord::RecordInvalid)
        expect(e.record.errors[:email]).to eq ["can't be blank"]
      end
    end
  end

  context "with blank password" do
    before { params[:registration][:password] = "" }
    it "raises record invalid exception with proper error" do
      expect { subject }.to raise_error do |e|
        expect(e).to be_a(ActiveRecord::RecordInvalid)
        expect(e.record.errors[:password]).to eq ["can't be blank"]
      end
    end
  end

  context "with all valid params" do
    it "returns registration object wrapping new user created" do
      user = subject.user
      expect(user).to be_a User
      expect(user.email).to eq params[:registration][:email]
      expect(user.profile.screen_name).to eq params[:registration][:screen_name]
    end
  end
end
