class Post
  include Mongoid::Document

  field :body,  type: String
  field :title, type: String

  field :tag_ids,       type: Array
  field :food_ids,      type: Array
  field :symptom_ids,   type: Array
  field :condition_ids, type: Array
  field :treatment_ids, type: Array

  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  validates :body, :title, :encrypted_user_id, presence: true

  has_many :comments

  def user_name
    Profile.find_by!(user_id: SymmetricEncryption.decrypt(encrypted_user_id)).screen_name
  end

  %w(tag food symptom condition treatment).each do |relative|
    pluralized_relative = relative.pluralize

    define_method(:"#{pluralized_relative}") do
      ivar_name = :"@_#{pluralized_relative}"

      value = instance_variable_get(ivar_name)

      return value if value.present?

      value = instance_variable_set(ivar_name, relative.classify.constantize.where(id: send("#{relative}_ids")))

      value
    end
  end
end
