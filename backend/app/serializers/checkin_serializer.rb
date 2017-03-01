class CheckinSerializer < ApplicationSerializer
  attributes :id, :date, :note, :tag_ids, :food_ids, :postal_code, :available_for_hbi?

  has_many :conditions, embed: :objects, serializer: CheckinConditionSerializer
  has_many :symptoms, embed: :objects, serializer: CheckinSymptomSerializer
  has_many :treatments, embed: :objects, serializer: CheckinTreatmentSerializer

  has_one :weather, embed_in_root: true
  has_many :tags, embed_in_root: true
  has_many :foods, embed_in_root: true

  has_one :harvey_bradshaw_index, embed_in_root: true

  def harvey_bradshaw_index
    object.harvey_bradshaw_index if show_single_relation?(:harveyBradshawIndices)
  end

  def weather
    object.weather if show_single_relation?(:weathersMeasures)
  end

  %w(condition symptom treatment).each do |name|
    plural_name = name.pluralize

    define_method(plural_name.to_sym) do
      query = object.includes ? { "#{name}_id" => { '$in': (object.includes[plural_name] || []).map(&:to_i) } } : {}

      object.send(plural_name).where(query)
    end
  end

  private

  def show_single_relation?(key)
    !object.includes || (object.includes && object.includes[key].present?)
  end
end
