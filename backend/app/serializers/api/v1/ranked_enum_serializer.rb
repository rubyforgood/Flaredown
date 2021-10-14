module Api
  module V1
    class RankedEnumSerializer < ApplicationSerializer
      attributes :id, :name, :rank
    end
  end
end
