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
    def count_by_types
      reduce_count.map { |n| [n[ID], n.dig(VALUE, TOTAL).to_i] }.to_h
    end

    private

    def reduce_count
      map_reduce(MAP_COUNT, REDUCE_COUNT).out(inline: true).to_a
    end
  end
end
