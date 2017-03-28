class Post
  include Mongoid::Document
  include Usernameable

  TOPIC_TYPES = %w(tag food symptom condition treatment).freeze

  field :body,  type: String
  field :title, type: String

  field :tag_ids,       type: Array
  field :food_ids,      type: Array
  field :symptom_ids,   type: Array
  field :condition_ids, type: Array
  field :treatment_ids, type: Array

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  field :comments_count, type: Fixnum, default: 0

  validates :body, :title, :encrypted_user_id, presence: true

  validate :topic_presence

  def comments
    Comment.where(post_id: id).order_by(created_at: :asc)
  end

  TOPIC_TYPES.each do |relative|
    pluralized_relative = relative.pluralize

    define_method(:"#{pluralized_relative}") do
      ivar_name = :"@_#{pluralized_relative}"

      value = instance_variable_get(ivar_name)

      return value if value.present?

      value = instance_variable_set(ivar_name, relative.classify.constantize.where(id: send("#{relative}_ids")))

      value
    end
  end

  private

  def topic_presence
    TOPIC_TYPES.each { |topic| return true if send(topic.pluralize).any? }

    errors.add(:topics, 'should have at list one entry')
  end
end
