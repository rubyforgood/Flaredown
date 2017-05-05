class GroupNotifiersPerUser
  include Sidekiq::Worker

  def perform(encrypted_user_id)
    active_notifications = Notification.where(encrypted_notify_user_id: encrypted_user_id, delivered: false)
    if active_notifications.any?
      aggregate_data = active_notifications
                        .groupped_by_post_and_kind(encrypted_user_id)
      NotificationsMailer.notify(email: user_email(encrypted_user_id), data: aggregate_data).deliver_later
      clean_notifications(active_notifications)
    end
  end

  private

    def user_email(encrypted_user_id)
      Profile.select(:user_id).find_by(user_id: SymmetricEncryption.decrypt(encrypted_user_id)).user.email
    end

    def clean_notifications(active_notifications)
      active_notifications.batch_size(500).each {|notification| notification.update_attributes(delivered: true) }
    end
end
