class Reaction
  include Mongoid::Document

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
      reactions_for_user = where(encrypted_user_id: encrypted_user_id).pluck(:value)

      aggregation = criteria.group(:_id => "$value", :count.sum => 1)
      collection.aggregate(aggregation.pipeline).map do |reaction|
        {
          id: SecureRandom.hex(16), # needed for Ember UI - is there a better way?
          value: reaction["_id"],
          count: reaction["count"],
          participated: reactions_for_user.include?(reaction["_id"])
        }
      end
    end
  end
end
