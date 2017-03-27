class FoodSerializer < ApplicationSerializer
  include SearchableSerializer

  attributes :id, :name
end
