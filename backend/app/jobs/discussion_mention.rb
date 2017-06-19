class DiscussionMention
  include Sidekiq::Worker

  NAME_REGEXP = /@\w+/

  def perform(encrypted_user_id, comment_id)
    comment = Comment.find(comment_id)
    profiles = found_profiles(comment.body)
    return if profiles.empty?

    create_notifications(encrypted_user_id, profiles.map(&:user_id), comment)
  end

  private

  def found_profiles(mentioned_string)
    selected_names = mentioned_string.scan(NAME_REGEXP).uniq

    selected_names.each_with_object([]) do |matched_string, result_array|
      matched_string.slice!(0) # remove '@ tag'

      profile = Profile.find_by(slug_name: matched_string)
      result_array << profile if profile
    end
  end

  def create_notifications(encrypted_user_id, user_ids, comment_id)
    encrypted_notify_user_ids = user_ids.map { |user_id| SymmetricEncryption.encrypt(user_id) }
    comment = Comment.find(comment_id)

    encrypted_notify_user_ids.map do |encrypted_notify_user_id|
      Notification.create(
        kind: :mention,
        notificateable: comment,
        encrypted_user_id: encrypted_user_id,
        encrypted_notify_user_id: encrypted_notify_user_id
      )
    end
  end
end
