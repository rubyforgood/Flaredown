module Api
  module V1
    class CheckinTreatmentSerializer < CheckinTrackableSerializer
      attributes :treatment_id, :is_taken
      has_one :dose, embed: :object

      private

      def dose
        ::Dose.new(name: object.value) if object.value.present?
      end
    end
  end
end
