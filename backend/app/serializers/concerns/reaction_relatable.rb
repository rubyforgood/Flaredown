module ReactionRelatable
  extend ActiveSupport::Concern

  included do
    attributes :reactions
  end

  def reactions
    ReactionSerializer.new(
      object.reactions.values_count_with_participated(current_user&.encrypted_id),
      object.id,
      object.class.name
    )
  end
end
