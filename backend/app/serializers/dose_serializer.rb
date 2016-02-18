class DoseSerializer < ApplicationSerializer
  include SearchableSerializer

  attributes :id, :name
end
