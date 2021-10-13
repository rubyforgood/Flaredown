class Reaction
  include Mongoid::Document

  ID = "_id".freeze
  VALUE = "value".freeze
  TOTAL = "total".freeze
  USER_ID = "encrypted_user_id".freeze
  PARTICIPATED = "participated".freeze

  MAP_COUNT = <<-JS.strip_heredoc.freeze
    function() {
      emit(
        this.value,
        {
          _id: this._id.str,
          total: 1,
          encrypted_user_id: this.encrypted_user_id
        }
      );
    }
  JS

  field :value, type: String
  field :encrypted_user_id, type: String, encrypted: {type: :integer}

  validates :value, :reactable, :encrypted_user_id, presence: true

  belongs_to :reactable, polymorphic: true

  class << self
    def similar_to(reaction)
      where(
        value: reaction.value,
        reactable_id: reaction.reactable_id,
        reactable_type: reaction.reactable_type
      )
    end

    def values_count_with_participated(encrypted_user_id)
      normalized_reactions(
        encrypted_user_id,
        map_reduce(MAP_COUNT, reduce_count(encrypted_user_id)).out(inline: 1).to_a
      )
    end

    private

    def normalized_reactions(encrypted_user_id, raw_reactions)
      raw_reactions.map do |reaction|
        participated = reaction.dig(VALUE, PARTICIPATED)

        {
          id: reaction.dig(VALUE, ID),
          value: reaction[ID],
          count: reaction.dig(VALUE, TOTAL).to_i,
          participated: participated.nil? ? reaction.dig(VALUE, USER_ID) == encrypted_user_id : participated
        }
      end
    end

    def reduce_count(encrypted_user_id)
      <<-JS.strip_heredoc.freeze
        function(key, valuesGroup){
          var r = {
            total: 0,
            participated: false,
          };

          for (var idx  = 0; idx < valuesGroup.length; idx++) {
            var value = valuesGroup[idx];

            r.total += valuesGroup[idx].total;

            if (!r._id) {
              r._id = value._id;
            }

            if (!r.participated && value.encrypted_user_id === "#{encrypted_user_id}") {
              r.participated = true;
            }
          }

          return r;
        }
      JS
    end
  end
end
