class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Usernameable

  after_initialize :set_defaults

  field :kind, type: String
  field :encrypted_user_id, type: String, encrypted: {type: :integer}
  field :encrypted_notify_user_id, type: String, encrypted: {type: :integer}
  field :delivered, type: Boolean, default: false
  field :post_id, type: String
  field :unread, type: Boolean, default: true

  validates :notificateable, :encrypted_user_id, :encrypted_notify_user_id, presence: true

  belongs_to :notificateable, polymorphic: true

  index notificateable_id: 1, notificateable_type: 1

  def set_defaults
    assign_attributes(post_id: ((notificateable._type == "Comment") ? notificateable.post_id : notificateable.id).to_s)
  end

  class << self
    def aggregated_by_kind_and_subject
      group = {}

      each do |n|
        key = [n.kind, n.notificateable_id.to_s, n.notificateable_type.downcase]

        group[key] ||= []
        group[key] << n
      end

      normalized_notifications(group)
    end

    def count_by_types
      group = criteria.group(_id: "$kind", count: {"$sum": 1})
      aggregate = collection.aggregate(group.pipeline)
      aggregate.reduce({}) { |acc, notification|
        h = {notification["_id"] => notification["count"]}
        acc.merge(h)
      }
    end

    def groupped_by_post_and_kind(encrypted_user_id)
      where(encrypted_notify_user_id: encrypted_user_id)
        .group_by(&:post_id).deep_transform_keys!(&:to_s)
        .each_with_object({}) { |obj, hash| hash[obj[0]] = aggregate_group(obj[1].group_by(&:kind)) }
    end

    private

    def normalized_notifications(group)
      group.map do |group_keys, notifications|
        notificateable = notifications.first.notificateable
        is_comment = notificateable._type == "Comment"

        {
          id: [notifications.map(&:created_at).max.to_i].concat(group_keys).join("_"),
          kind: group_keys.first,
          count: notifications.count,
          post_id: is_comment ? notificateable.post_id.to_s : group_keys[1],
          post_title: (is_comment ? notificateable.post : notificateable)&.title,
          notificateable_id: group_keys[1],
          notificateable_type: group_keys.last,
          unread: notifications.map(&:unread).last,
          notifier_username: notifier_username(notifications)
        }
      end
    end

    def aggregate_group(groupped_by_kind)
      groupped_by_kind.each_with_object({}) { |kind, hash| hash[kind[0]] = kind[1].count }
    end

    def notifier_username(notifications)
      notifier_user_id = SymmetricEncryption.decrypt(notifications.first.encrypted_user_id)
      Profile.find_by(user_id: notifier_user_id)&.screen_name
    end
  end
end
