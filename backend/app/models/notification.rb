class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Usernameable

  ID = '_id'.freeze
  VALUE = 'value'.freeze
  TOTAL = 'total'.freeze

  MAP_COUNT = <<-JS.strip_heredoc.gsub(/\s+/, ' ').freeze
    function() {
      emit(
        this.kind,
        {
          total: 1,
        }
      );
    }
  JS

  REDUCE_COUNT = <<-JS.strip_heredoc.gsub(/\s+/, ' ').freeze
    function(key, valuesGroup){
      var r = {
        total: 0,
      };

      for (var idx  = 0; idx < valuesGroup.length; idx++) {
        r.total += valuesGroup[idx].total;
      }

      return r;
    }
  JS

  field :kind, type: String
  field :encrypted_user_id, type: String, encrypted: { type: :integer }
  field :encrypted_notify_user_id, type: String, encrypted: { type: :integer }

  validates :notificateable, :encrypted_user_id, :encrypted_notify_user_id, presence: true

  belongs_to :notificateable, polymorphic: true

  index notificateable_id: 1, notificateable_type: 1

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
      reduce_count.map { |n| [n[ID], n.dig(VALUE, TOTAL).to_i] }.to_h
    end

    private

    def reduce_count
      map_reduce(MAP_COUNT, REDUCE_COUNT).out(inline: true).to_a
    end

    def normalized_notifications(group)
      group.map do |group_keys, notifications|
        notificateable = notifications.first.notificateable
        is_comment = notificateable._type == 'Comment'

        {
          id: [notifications.map(&:created_at).max.to_i].concat(group_keys).join('_'),
          kind: group_keys.first,
          count: notifications.count,
          post_id: is_comment ? notificateable.post_id.to_s : group_keys[1],
          post_title: (is_comment ? notificateable.post : notificateable).title,
          notificateable_id: group_keys[1],
          notificateable_type: group_keys.last
        }
      end
    end
  end
end
