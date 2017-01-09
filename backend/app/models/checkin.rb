class Checkin
  include Mongoid::Document

  #
  # Fields
  #
  field :date,        type: Date
  field :food_ids,    type: Array, default: []
  field :note,        type: String
  field :postal_code, type: String
  field :tag_ids,     type: Array
  field :encrypted_user_id, type: String, encrypted: { type: :integer }
  field :weather_id,  type: Integer

  #
  # Relations
  #
  has_many :treatments, class_name: 'Checkin::Treatment'
  has_many :conditions, class_name: 'Checkin::Condition'
  has_many :symptoms, class_name: 'Checkin::Symptom'
  accepts_nested_attributes_for :conditions, :symptoms, :treatments, allow_destroy: true

  #
  # Indexes
  #
  index(encrypted_user_id: 1)
  index(date: 1, encrypted_user_id: 1)

  #
  # Validations
  #
  validates :encrypted_user_id, presence: true
  validates :date, presence: true, uniqueness: { scope: :encrypted_user_id }

  #
  # Scopes
  #
  scope :by_date, ->(startkey, endkey) { where(:date.gte => startkey, :date.lte => endkey) }

  def user
    @user ||= User.find(user_id)
  end

  def weather
    @weather ||= Weather.find_by(id: weather_id)
  end
end
