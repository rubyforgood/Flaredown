module Api
  module V1
    class CheckinSymptomSerializer < CheckinTrackableSerializer
      attributes :symptom_id
    end
  end
end
