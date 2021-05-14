module Topicable
  extend ActiveSupport::Concern

  include Mongoid::Document
  include Mongoid::Timestamps

  TOPIC_TYPES = %w[tag symptom condition treatment].freeze

  included do
    field :tag_ids, type: Array, default: []
    field :symptom_ids, type: Array, default: []
    field :condition_ids, type: Array, default: []
    field :treatment_ids, type: Array, default: []

    field :encrypted_user_id, type: String, encrypted: {type: :integer}

    validates :encrypted_user_id, presence: true

    TOPIC_TYPES.each do |relative|
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
end
