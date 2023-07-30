class Post
  include Topicable
  include Usernameable

  attr_accessor :postable_id

  store_in collection: "postables"

  field :body, type: String
  field :title, type: String
  field :_type, type: String, default: -> { self.class.name }

  field :comments_count, type: Integer, default: 0
  field :last_commented, type: DateTime, default: -> { Time.current }
  field :comment_reaction_count, type: Integer, default: 0

  validates :body, :title, presence: true

  validate :topic_presence

  has_many :comments, dependent: :destroy
  has_many :reactions, as: :reactable, dependent: :destroy
  has_many :notifications, as: :notificateable, dependent: :destroy

  index(body: "text", title: "text")

  def update_counters
    set comment_reaction_count: comments_count + reactions.count
  end

  def self.fts(q)
    where("$text": {"$search": q, "$language": I18n.locale.to_s})
  end

  def self.by_followings(followings)
    any_of(
      {:tag_ids.in => followings.tag_ids},
      {:symptom_ids.in => followings.symptom_ids},
      {:condition_ids.in => followings.condition_ids},
      {:treatment_ids.in => followings.treatment_ids} # rubocop:disable Style/BracesAroundHashParameters
    )
  end

  def self.frequency_by(topic_following)
    where(_type: "Post")
      .by_followings(topic_following)
      .each_with_object({}) do |post, hash|
        result_count = 0
        %w[symptom_ids condition_ids tag_ids treatment_ids].each do |trackable|
          result_count += (post.send(trackable) & topic_following.send(trackable)).count
        end
        hash[post.id] = result_count
      end
  end

  private

  def topic_presence
    TOPIC_TYPES.each { |topic| return true if send(topic.pluralize).any? }

    errors.add(:topics, "should have at least one of associated #{TOPIC_TYPES.join(",")}")
  end
end
