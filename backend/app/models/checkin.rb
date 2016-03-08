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

  def most_recent_value_for(trackable_type, trackable_id)
    return nil unless %w(
      Checkin::Treatment
      Checkin::Condition
      Checkin::Symptom
    ).include? trackable_type
    trackable_id_sym = "#{trackable_type.split('::')[1].underscore}_id".to_sym
    trackable_type.constantize.in(checkin_id: user.checkin_ids)
      .where(:value.ne => nil, trackable_id_sym => trackable_id)
      .order_by('checkin.date' => 'desc').first.try(:value)
  end

end
