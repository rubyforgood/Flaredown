class Checkin
  include Mongoid::Document

  #
  # Fields
  #
  field :date,       type: Date
  field :user_id,    type: Integer

  #
  # Relations
  #
  has_and_belongs_to_many :tags, class_name: 'Checkin::Tag'

  #
  # Validations
  #
  validates :user_id, presence: true

  validates :date, presence: true, uniqueness: { scope: :user_id }
end
