class Checkin
  include Mongoid::Document

  HBI_PERIODICITY = 7

  attr_accessor :includes

  #
  # Fields
  #
  field :date,        type: Date
  field :food_ids,    type: Array, default: []
  field :note,        type: String
  field :postal_code, type: String
  field :tag_ids,     type: Array
  field :weather_id,  type: Integer
  field :encrypted_user_id, type: String, encrypted: { type: :integer }

  #
  # Relations
  #
  # these getters are redefined below
  has_one :harvey_bradshaw_index
  has_many :treatments, class_name: 'Checkin::Treatment'
  has_many :conditions, class_name: 'Checkin::Condition'
  has_many :symptoms, class_name: 'Checkin::Symptom'
  accepts_nested_attributes_for :conditions, :symptoms, :treatments, allow_destroy: true

  #
  # Indexes
  #
  index(encrypted_user_id: 1)
  index(date: 1, encrypted_user_id: 1)

  #
  # Validations
  #
  validates :encrypted_user_id, presence: true
  validates :date, presence: true, uniqueness: { scope: :encrypted_user_id }

  #
  # Scopes
  #
  scope :by_date, ->(startkey, endkey) { where(:date.gte => startkey, :date.lte => endkey) }

  def user
    @user ||= User.find(user_id)
  end

  def harvey_bradshaw_index
    cached_one_with_includes('hbi', :harveyBradshawIndices) do
      HarveyBradshawIndex.where(checkin_id: id).first # rubocop:disable Rails/FindBy
    end
  end

  def weather
    cached_one_with_includes('weather', :weathersMeasures) do
      Weather.find_by(id: weather_id)
    end
  end

  def tags
    if includes
      @_tags_included ||= Tag.where(id: includes[:tags] || [])
    else
      @_tags ||= Tag.where(id: tag_ids)
    end
  end

  def foods
    if includes
      @_foods_included ||= Food.where(id: includes[:foods] || [])
    else
      @_foods ||= Food.where(id: food_ids)
    end
  end

  def available_for_hbi?
    return true if harvey_bradshaw_index
    return false unless date.today?
    return true unless latest_hbi

    HBI_PERIODICITY - ((latest_hbi.date)...date).count < 1
  end

  %w(condition symptom treatment).each do |name|
    plural_name = name.pluralize

    define_method(plural_name.to_sym) do
      result = nil
      ivar_name = nil

      if includes
        ivar_name = "@_#{plural_name}_included"

        return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)

        result = "Checkin::#{name.titleize}"
          .constantize
          .where(
            :checkin_id => id,
            "#{name}_id" => { '$in': (includes[plural_name] || []).map(&:to_i) }
          )
          .to_a
      else
        ivar_name = "@_#{plural_name}"

        return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)

        result = "Checkin::#{name.titleize}".constantize.where(checkin_id: id).to_a
      end

      instance_variable_set(ivar_name, result)
    end
  end

  class Condition
    include Mongoid::Document
    include Checkin::Trackable
    include Checkin::Fiveable

    field :condition_id, type: Integer

    validates :condition_id, uniqueness: { scope: :checkin_id }
  end

  class Symptom
    include Mongoid::Document
    include Checkin::Trackable
    include Checkin::Fiveable

    field :symptom_id, type: Integer

    validates :symptom_id, uniqueness: { scope: :checkin_id }
  end

  class Treatment
    include Mongoid::Document
    include Checkin::Trackable

    #
    # Fields
    #
    field :treatment_id, type: Integer
    field :value, type: String
    field :is_taken, type: Boolean

    #
    # Indexes
    #
    index(treatment_id: 1)
    index(treatment_id: 1, is_taken: 1, value: 1)

    #
    # Validations
    #
    validates :treatment_id, uniqueness: { scope: :checkin_id }
  end

  private

  def latest_hbi
    @_latest_hbi ||= HarveyBradshawIndex.where(encrypted_user_id: encrypted_user_id).order(date: :desc).first
  end

  def cached_one_with_includes(name, key)
    ivar_name = includes ? :"@_#{name}_included" : :"@_#{name}"

    return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)

    result = yield if !includes || (includes && includes[key].present?)

    instance_variable_set(ivar_name, result)

    result
  end
end
