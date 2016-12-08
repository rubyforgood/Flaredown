class FoodSerializer < ApplicationSerializer
  include SearchableSerializer

  attributes :id, :long_desc
end
