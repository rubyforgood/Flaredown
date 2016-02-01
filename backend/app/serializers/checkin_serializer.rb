class CheckinSerializer < ApplicationSerializer

  class KeyValueSerializer < ActiveModel::Serializer
    attributes :id, :value

    def id
      object.try(:condition_id) || object.try(:symptom_id) || object.try(:treatment_id)
    end

    def value
      object.try(:value) || object.try(:dose)
    end
  end

  attributes :id, :date


  has_many :conditions, embed: :objects, serializer: KeyValueSerializer
  has_many :symptoms, embed: :objects, serializer: KeyValueSerializer
  has_many :treatments, embed: :objects, serializer: KeyValueSerializer

end
