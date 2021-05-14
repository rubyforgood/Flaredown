# == Schema Information
#
# Table name: treatments
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  trackable_usages_count :integer          default(0)
#

class Treatment < ActiveRecord::Base
  has_many :treatment_translations, class_name: "Treatment::Translation"

  #
  # Localized attributes
  #
  translates :name
end
