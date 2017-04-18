class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Reactable
  include Usernameable

  store_in collection: 'postables'

  field :body,              type: String
  field :_type,             type: String, default: -> { self.class.name }
  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :body, :post, :encrypted_user_id, presence: true

  belongs_to :post, index: true, counter_cache: true
end
