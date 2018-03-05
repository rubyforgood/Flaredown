class SendDataToSendy
  include Sidekiq::Worker

  def perform(options)
    email = options['email']
    return unless email.present?

    user = User.find_by(email: email)
    return unless user

    last_checkin_at = options['last_checkin_at'] || ''

    SendyService.new(name: options['name'],
                     email: email,
                     signup_at: user.created_at.to_date,
                     last_checkin_at: last_checkin_at).send_data
  end
end
