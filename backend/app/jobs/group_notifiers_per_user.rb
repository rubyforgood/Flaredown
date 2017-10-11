class GroupNotifiersPerUser
  include Sidekiq::Worker

  def perform(encrypted_user_id)
    user = User.find(SymmetricEncryption.decrypt(encrypted_user_id))
    return unless user&.notify
    return if user&.rejected_type.present? # Rejected via AWS SES

    active_notifications = Notification.where(encrypted_notify_user_id: encrypted_user_id, delivered: false)
    return if active_notifications.none?

    aggregate_data = active_notifications.groupped_by_post_and_kind(encrypted_user_id)

    NotificationsMailer.notify(email: user.email, data: aggregate_data).deliver_later

    clean_notifications(active_notifications)
  end

  private

  def clean_notifications(active_notifications)
    active_notifications.batch_size(500).each { |notification| notification.update_attributes(delivered: true) }
  end
end
