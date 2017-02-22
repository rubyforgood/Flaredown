class HarveyBradshawIndex
  include Mongoid::Document

  #
  # Fields
  #
  field :date, type: Date

  field :score,           type: Integer
  field :stools,          type: Integer
  field :well_being,      type: Integer
  field :abdominal_mass,  type: Integer
  field :abdominal_pain,  type: Integer

  field :abscess,               type: Boolean
  field :uveitis,               type: Boolean
  field :arthralgia,            type: Boolean
  field :new_fistula,           type: Boolean
  field :anal_fissure,          type: Boolean
  field :aphthous_ulcers,       type: Boolean
  field :erythema_nodosum,      type: Boolean
  field :pyoderma_gangrenosum,  type: Boolean

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  #
  # Relations
  #
  belongs_to :checkin, index: true

  #
  # Indexes
  #
  index(date: 1, encrypted_user_id: 1)

  #
  # Validations
  #
  validates :checkin, :stools, :well_being, :abdominal_mass, :abdominal_pain, presence: true
  validates :checkin_id, uniqueness: true

  #
  # Callbacks
  #
  before_save   :calculate_score
  before_create :set_date_and_user_id

  private

  def set_date_and_user_id
    self.date = checkin.date
    self.encrypted_user_id = checkin.encrypted_user_id
  end

  def calculate_score
    self.score = stools + well_being + abdominal_mass + abdominal_pain

    self.score += [
      abscess,
      uveitis,
      arthralgia,
      new_fistula,
      anal_fissure,
      aphthous_ulcers,
      erythema_nodosum,
      pyoderma_gangrenosum
    ].count { |v| v }
  end
end
