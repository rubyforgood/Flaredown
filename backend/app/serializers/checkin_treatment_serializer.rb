class CheckinTreatmentSerializer < ApplicationSerializer
  attributes :id, :treatment_id, :value

  def value
    object.dose
  end
end
