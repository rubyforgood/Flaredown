# == Schema Information
#
# Table name: conditions
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  name                   :string
#  trackable_usages_count :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Condition < ActiveRecord::Base
  has_many :condition_translations, class_name: "Condition::Translation"

  #
  # Localized attributes
  #
  translates :name
end
