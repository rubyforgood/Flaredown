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
      reactions_for_user = where(encrypted_user_id: encrypted_user_id).pluck(:value, :_id).to_h

      aggregation = criteria.group(:_id => "$value", :count.sum => 1)
      collection.aggregate(aggregation.pipeline).map do |reaction|
        # A real ID is only required when the current user has reacted. Otherwise the value is meaningless
        # Use a random string to try to demonstrate that
        {
          id: (reactions_for_user[reaction["_id"]] || SecureRandom.hex(16)).to_s,
          value: reaction["_id"],
          count: reaction["count"],
          participated: reactions_for_user.key?(reaction["_id"])
        }
      end
    end
  end
end
