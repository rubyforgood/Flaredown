class FoodSerializer < ApplicationSerializer
  include SearchableSerializer

  attributes :id, :name

  def name
    object.respond_to?(:name) ? object.name : object.long_desc
  end
end
