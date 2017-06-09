class DiscussionMention
  include Sidekiq::Worker

  NAME_REGEXP = /@\w+/

  def perform(encrypted_user_id, comment_id)
    comment = Comment.find(comment_id)

    profiles = parse_screen_name(comment.body).uniq
    return unless profiles

    notifier_username = Profile.find_by(user_id: SymmetricEncryption.decrypt(encrypted_user_id)).screen_name
    create_notifications(notifier_username, encrypted_user_id, profiles.map(&:user_id), comment)

    profiles.map(&:user).map(&:email).map do |email|
      DiscussionMentionMailer.notify(notifier_username, email).deliver_later
    end
  end

  private

  def parse_screen_name(mentioned_string)
    parsed_body_arr(mentioned_string).each_with_object([]) do |matched_string, result_array|
      matched_string.slice!(0) # remove '@ tag'

      profile = Profile.find_by(slug_name: matched_string)
      result_array << profile if profile
    end
  end

  def parsed_body_arr(mentioned_string)
    comment_body = mentioned_string

    [].tap do |arr|
      loop do
        matched_string = comment_body.match(NAME_REGEXP)
        break unless matched_string
        arr << comment_body.slice!(matched_string.to_s) # remove match from incoming string for next iteration
      end
    end
  end

  def create_notifications(username, encrypted_user_id, user_ids, comment_id)
    encrypted_notify_user_ids = user_ids.map { |user_id| SymmetricEncryption.encrypt(user_id) }
    comment = Comment.find(comment_id)

    encrypted_notify_user_ids.map do |encrypted_notify_user_id|
      Notification.create(
        kind: :mention,
        notificateable: comment,
        encrypted_user_id: encrypted_user_id,
        notifier_username: username,
        encrypted_notify_user_id: encrypted_notify_user_id
      )
    end
  end
end
