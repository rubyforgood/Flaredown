# == Schema Information
#
# Table name: treatments
#
#  id         :integer          not null, primary key
#  global     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Treatment < ActiveRecord::Base
  #
  # Localized attributes
  #
  translates :name
end
