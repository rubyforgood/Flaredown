# == Schema Information
#
# Table name: symptoms
#
#  id         :integer          not null, primary key
#  global     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Symptom < ActiveRecord::Base

  #
  # Localized attributes
  #
  translates :name

end
