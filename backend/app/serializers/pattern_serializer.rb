class PatternSerializer < ApplicationSerializer
  attributes :id, :start_at, :end_at, :name, :includes
end
