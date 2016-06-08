class Registration
  include ActiveModel::Validations
  include ActiveModel::Serialization

  attr_reader :user
  attr_accessor :errors, :captcha_response, :screen_name

  validates :captcha_response, :screen_name, presence: true
  validate :captcha_response_verified

  def initialize(params)
    @user_params = permitted(params).to_hash
    @screen_name = @user_params.delete('screen_name')
    @captcha_response = @user_params.delete('captcha_response')
    @errors = ActiveModel::Errors.new(self)
  end

  def save!
    if valid?
      begin
        @user = User.create!(@user_params)
        @user.profile.update_attributes!(screen_name: screen_name) if screen_name.present?
      rescue ActiveRecord::RecordInvalid => e
        self.errors = e.record.errors
        raise ActiveRecord::RecordInvalid.new(self)
      end
      self
    else
      fail ActiveRecord::RecordInvalid.new(self)
    end
  end

  def self.create!(params)
    self.new(params).save!
  end

  # Use AR's i18n scope so that we can raise RecordInvalid exceptions
  def self.i18n_scope
    :activerecord
  end

  private

  def permitted(params)
    params.require(:registration).permit(
      :email, :password, :password_confirmation, :screen_name, :captcha_response
    )
  end

  def captcha_response_verified
    verified = Google::RecaptchaVerifier.exec(captcha_response)
    errors.add(:captcha_response, 'verification failed') unless verified
  end

end
