class Pattern
  include Mongoid::Document
  include Mongoid::Timestamps

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  index(encrypted_user_id: 1)

  validates :encrypted_user_id, presence: true

  before_create :set_encrypted_user_id


  def trackables
    @_trackables ||= trackings.map(&:trackable)
  end

  private

  def trackings
    return Tracking.none if includes.blank?

    relation = Tracking.includes(:trackable)

    relation
      .where(trackable_type: :Condition, trackable_id: includes[:conditions] || [])
      .or(relation.where(trackable_type: :Symptom, trackable_id: includes[:symptoms] || []))
      .or(relation.where(trackable_type: :Treatment, trackable_id: includes[:treatments] || []))
      .where(user_id: user.id)
      .active_in_range(start_at.to_date, end_at.to_date)
  end

  def set_encrypted_user_id
    self.encrypted_user_id = SymmetricEncryption.encrypt(current_user.id)
  end
end
