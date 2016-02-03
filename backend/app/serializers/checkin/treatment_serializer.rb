class Checkin::TreatmentSerializer < ApplicationSerializer
  attributes :id, :treatment_id, :value

  def value
    object.dose
  end
end
