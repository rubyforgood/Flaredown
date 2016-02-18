class SearchSerializer < ApplicationSerializer
  attributes :id

  has_many :searchables, embed: :objects
end
