Mongoid.configure do |config|
  config.load_defaults 8.1
end

Mongoid::Document.send(:include, ActiveModel::SerializerSupport)
Mongoid::Criteria.delegate(:active_model_serializer, to: :to_a)

module BSON
  class ObjectId
    alias_method :to_json, :to_s
    alias_method :as_json, :to_s
  end
end
