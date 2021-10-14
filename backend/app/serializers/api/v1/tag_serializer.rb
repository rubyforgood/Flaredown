# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Api
  module V1
    class TagSerializer < ApplicationSerializer
      include SearchableSerializer
      attributes :id, :name, :users_count

      def users_count
        object.trackable_usages_count
      end
    end
  end
end
