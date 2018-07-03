class Registration
  include ActiveModel::Validations
  include ActiveModel::Serialization

  attr_accessor :user, :errors, :captcha_response, :screen_name, :birth_date

  validates :captcha_response, :screen_name, presence: true
  validate :captcha_response_verified

  def initialize(params)
    @user_params = permitted(params).to_hash
    @screen_name = @user_params.delete('screen_name')
    @birth_date = params.dig(:registration, :birth_date)
    @captcha_response = @user_params.delete('captcha_response')
    @errors = ActiveModel::Errors.new(self)
  end

  def save!
    # FIXME
    # rubocop:disable Style/SignalException
    fail ActiveRecord::RecordInvalid, self unless valid?
    # rubocop:enable Style/SignalException

    begin
      @user = User.create!(@user_params)
      profile = @user.profile

      profile.birth_date = birth_date
      profile.screen_name = screen_name if screen_name.present?

      profile.save!

    rescue ActiveRecord::RecordInvalid => e
      self.errors = e.record.errors
      raise ActiveRecord::RecordInvalid, self
    end

    self
  end

  def self.create!(params)
    new(params).save!
  end

  def self.delete!(params)
    email = params[:email]
    user = User.find_by(email: email)
    return if user.blank?

    ActiveRecord::Base.transaction do
      user.profile.destroy!
      user.destroy!

      Feedback.create!(email: email, delete_reason: params[:delete_reason])
    end
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
    errors.add(:captcha_response, 'verification failed or response expired') unless verified
  end

end
