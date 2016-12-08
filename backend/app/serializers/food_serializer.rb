class FoodSerializer < ApplicationSerializer
  include SearchableSerializer

  attributes :id, :name

  def name
    object.long_desc
  end
end
