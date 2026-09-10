# == Schema Information
#
# Table name: user_tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer
#  user_id    :integer
#
# Indexes
#
#  index_user_tags_on_tag_id   (tag_id)
#  index_user_tags_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
class UserTag < ActiveRecord::Base
  #
  # Associations
  #
  belongs_to :user
  belongs_to :tag

  #
  # Validations
  #
  validates :user, :tag, presence: true
end
