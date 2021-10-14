module Api
  module V1
    class OracleRequestSerializer < ApplicationSerializer
      attributes :id, :age, :sex_id, :symptom_ids, :responce, :can_edit

      has_one :sex, embed_in_root: true
      has_many :symptoms, embed_in_root: true

      def can_edit
        object.can_edit?(scope)
      end
    end
  end
end
