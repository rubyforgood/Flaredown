module Api
  module V1
    class DoseSerializer < ApplicationSerializer
      include SearchableSerializer

      attributes :id, :name
    end
  end
end
