Mongoid::Document.send(:include, ActiveModel::SerializerSupport)
Mongoid::Criteria.delegate(:active_model_serializer, to: :to_a)

module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s
  end
end
