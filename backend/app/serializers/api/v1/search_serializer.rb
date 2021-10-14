module Api
  module V1
    class SearchSerializer < ApplicationSerializer
      attributes :id

      has_many :searchables, embed: :objects
    end
  end
end
