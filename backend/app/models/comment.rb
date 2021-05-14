class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Usernameable

  store_in collection: "postables"

  field :body, type: String
  field :_type, type: String, default: -> { self.class.name }
  field :encrypted_user_id, type: String, encrypted: {type: :integer}

  validates :body, :post, :encrypted_user_id, presence: true

  belongs_to :post, index: true, counter_cache: true

  has_many :reactions, as: :reactable, dependent: :destroy
  has_many :notifications, as: :notificateable, dependent: :destroy

  after_create { post.update_attributes(last_commented: Time.current) }
end
