# == Schema Information
#
# Table name: symptoms
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  trackable_usages_count :integer          default(0)
#

class Symptom < ActiveRecord::Base
  has_many :symptom_translations, class_name: "Symptom::Translation"

  #
  # Localized attributes
  #
  translates :name
end
