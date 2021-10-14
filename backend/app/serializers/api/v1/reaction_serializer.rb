module Api
  module V1
    class ReactionSerializer
      attr_reader :reactions, :reactable_id, :reactable_type

      def initialize(reactions, reactable_id, reactable_type)
        @reactions = reactions
        @reactable_id = reactable_id
        @reactable_type = reactable_type
      end

      def as_json(_opts = {})
        reactions.map { |reaction| serialized_reaction(reaction) }
      end

      def serialize_one
        {
          reaction: serialized_reaction(reactions.first)
        }
      end

      private

      def serialized_reaction(raw_reaction)
        raw_reaction.merge(reactable_id: reactable_id, reactable_type: reactable_type)
      end
    end
  end
end
