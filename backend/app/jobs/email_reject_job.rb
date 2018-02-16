class EmailRejectJob
  include Sidekiq::Worker

  def perform(recipients_hash)
    User.where(email: recipients_hash.values.first).includes(:profile).map do |user|
      user.profile.update_column(:rejected_type, recipients_hash.keys.first.to_s)
    end
  end
end
