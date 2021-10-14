module Api
  module V1
    class PatternSerializer < ApplicationSerializer
      attributes :id, :start_at, :end_at, :name, :includes, :author_name

      def author_name
        object.author.screen_name
      end
    end
  end
end
