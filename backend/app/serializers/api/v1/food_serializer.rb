module Api
  module V1
    class FoodSerializer < ApplicationSerializer
      include SearchableSerializer

      attributes :id, :name
    end
  end
end
