class TopicFollowing
  include Topicable

  def add_topic(key, value)
    return if send(key).include?(value)

    send(key) << value

    save
  end
end
