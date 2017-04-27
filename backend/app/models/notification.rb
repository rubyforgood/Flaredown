class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Usernameable

  ID = '_id'.freeze
  VALUE = 'value'.freeze
  TOTAL = 'total'.freeze
  NOTIFICATEABLE_ID = 'notificateable_id'.freeze
  NOTIFICATEABLE_TYPE = 'notificateable_type'.freeze

  MAP_COUNT = <<-JS.strip_heredoc.freeze
    function() {
      emit(
        this.kind,
        {
          _id: this._id.str,
          kind: this.kind,
          total: 1,
          notificateable_id: this.notificateable_id,
          notificateable_type: this.notificateable_type,
        }
      );
    }
  JS

  REDUCE_COUNT = <<-JS.strip_heredoc.freeze
    function(key, valuesGroup){
      var r = {
        total: 0,
      };

      for (var idx  = 0; idx < valuesGroup.length; idx++) {
        var value = valuesGroup[idx];

        r.total += valuesGroup[idx].total;

        if (!r._id) {
          r._id = value._id;
          r.notificateable_id = value.notificateable_id;
          r.notificateable_type = value.notificateable_type;
        }
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
    def aggregated_notifications
      normalized_notifications(reduce_count)
    end

    private

    def reduce_count
      map_reduce(MAP_COUNT, REDUCE_COUNT).out(inline: true).to_a
    end

    def normalized_notifications(raw_notifications)
      raw_notifications.map do |notification|
        {
          id: notification.dig(VALUE, ID),
          kind: notification[ID],
          count: notification.dig(VALUE, TOTAL).to_i,
          notificateable_id: notification.dig(VALUE, NOTIFICATEABLE_ID),
          notificateable_type: notification.dig(VALUE, NOTIFICATEABLE_TYPE)
        }
      end
    end
  end
end
