# == Schema Information
#
# Table name: conditions
#
#  id         :integer          not null, primary key
#  global     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ConditionSerializer < ApplicationSerializer
  attributes :id, :name
end
