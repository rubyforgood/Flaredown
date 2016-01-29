# == Schema Information
#
# Table name: treatments
#
#  id         :integer          not null, primary key
#  global     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TreatmentSerializer < ApplicationSerializer
  attributes :id, :name
end
