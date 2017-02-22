class HarveyBradshawIndex
  include Mongoid::Document

  #
  # Fields
  #
  field :date, type: Date

  field :stools,          type: Integer
  field :well_being,      type: Integer
  field :abdominal_mass,  type: Integer
  field :abdominal_pain,  type: Integer

  field :abscess,               type: String
  field :uveitis,               type: String
  field :arthralgia,            type: String
  field :new_fistula,           type: String
  field :anal_fissure,          type: String
  field :aphthous_ulcers,       type: String
  field :erythema_nodosum,      type: String
  field :encrypted_user_id,     type: String, encrypted: { type: :integer }
  field :pyoderma_gangrenosum,  type: String

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
  before_create :set_date_and_user_id

  private

  def set_date_and_user_id
    self.date = checkin.date
    self.encrypted_user_id = checkin.encrypted_user_id
  end
end
