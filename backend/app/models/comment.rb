class Comment
  include Mongoid::Document
  include Usernameable

  field :body,              type: String
  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :body, :post, :encrypted_user_id, presence: true

  belongs_to :post, index: true
end
