class Checkin
  include Mongoid::Document

  #
  # Fields
  #
  field :date,       type: Date
  field :user_id,    type: Integer
  field :note,       type: String
  field :tag_ids,    type: Array

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


  def user
    @user ||= User.find(user_id)
  end

  def most_recent_dose_for(treatment_id)
    result = nil
    recent_checkins = user.checkins.where(treatments: {"$ne" => []}).sort(date: -1).limit(100)
    recent_checkins.each do |checkin|
      taken_treatment = checkin.treatments.where(
        is_taken: true, treatment_id: treatment_id
      ).first
      result = taken_treatment.try(:value)
      result.present? ? break : next
    end
    result
  end

end
