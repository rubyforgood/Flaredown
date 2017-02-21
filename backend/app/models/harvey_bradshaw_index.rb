class HarveyBradshawIndex
  include Mongoid::Document

  #
  # Fields
  #
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
  field :pyoderma_gangrenosum,  type: String

  #
  # Relations
  #
  belongs_to :checkin, index: true

  #
  # Validations
  #
  validates :checkin, :stools, :well_being, :abdominal_mass, :abdominal_pain, presence: true
  validates :checkin_id, uniqueness: true
end
