class Checkin
  include Mongoid::Document

  #
  # Fields
  #
  field :date,       type: Date
  field :user_id,    type: Integer
  field :note,       type: String

  #
  # Relations
  #
  has_and_belongs_to_many :tags, class_name: 'Checkin::Tag'
  has_many :treatments, class_name: 'Checkin::Treatment'
  has_many :conditions, class_name: 'Checkin::Condition'
  has_many :symptoms, class_name: 'Checkin::Symptom'
  accepts_nested_attributes_for :conditions, :symptoms, :treatments, allow_destroy: true

  #
  # Indexes
  #
  index(user_id: 1)
  index(date: 1, user_id: 1)

  #
  # Validations
  #
  validates :user_id, presence: true
  validates :date, presence: true, uniqueness: { scope: :user_id }

  #
  # Scopes
  #
  scope :by_date, ->(startkey, endkey) { where(:date.gte => startkey, :date.lte => endkey) }


end
