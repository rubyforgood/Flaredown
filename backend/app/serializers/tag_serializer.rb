# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagSerializer < ApplicationSerializer
  include SearchableSerializer
  attributes :id, :name
end
