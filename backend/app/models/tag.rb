# == Schema Information
#
# Table name: tags
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  name                   :string
#  trackable_usages_count :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Tag < ActiveRecord::Base
  has_many :tag_translations, class_name: "Tag::Translation"

  #
  # Localized attributes
  #
  translates :name
end
