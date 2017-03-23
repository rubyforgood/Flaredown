class Post
  include Mongoid::Document

  field :body,  type: String
  field :title, type: String

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :body, :title, :encrypted_user_id, presence: true
end
