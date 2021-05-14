class Pattern
  include Mongoid::Document
  include Mongoid::Timestamps

  field :encrypted_user_id, type: String, encrypted: {type: :integer}
  field :start_at, type: Date
  field :end_at, type: Date
  field :includes, type: Array, default: []
  field :name, type: String

  index(encrypted_user_id: 1)

  validates :encrypted_user_id, presence: true

  def author
    @author ||= User.find_by(id: SymmetricEncryption.decrypt(encrypted_user_id))
  end
end
