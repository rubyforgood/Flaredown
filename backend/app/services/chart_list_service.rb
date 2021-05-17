class ChartListService
  TRACKABLES = %w[symptom condition treatment].freeze
  HBI_PAYLOAD = [[1, "Harvey Bradshaw Index".freeze, true].freeze].freeze
  WEATHERS_PAYLOAD = [
    [1, "Avg daily humidity".freeze, true].freeze,
    [2, "Avg daily atmospheric pressure".freeze, true].freeze
  ].freeze

  attr_reader :user

  def initialize(current_user:)
    @user = current_user
  end

  def as_json
    {
      chart_list: {
        id: 1,
        payload: {
          tags: tags_payload,
          foods: foods_payload,
          symptoms: symptoms_payload,
          conditions: conditions_payload,
          treatments: treatments_payload,
          weathersMeasures: weathers_payload,
          harveyBradshawIndices: hbi_payload
        }
      }
    }
  end

  private

  def tag_ids
    user.checkins.distinct(:tag_ids)
  end

  def food_ids
    user.checkins.distinct(:food_ids)
  end

  def checkin_ids
    @_user_checkin_ids ||= user.checkins.distinct(:id)
  end

  def last_checkin
    @_last_checkin ||= user.last_checkin
  end

  def tags_payload
    Tag::Translation
      .where(tag_id: tag_ids, locale: I18n.locale)
      .pluck(:tag_id, :name)
      .map { |payload| payload << last_checkin.tag_ids.include?(payload.first) }
  end

  def foods_payload
    Food::Translation
      .where(food_id: food_ids, locale: I18n.locale)
      .pluck(:food_id, :long_desc)
      .map { |payload| payload << last_checkin.food_ids.include?(payload.first) }
  end

  def weathers_payload
    last_checkin&.weather_id ? WEATHERS_PAYLOAD : WEATHERS_PAYLOAD.map { |p| [p[0], p[1], false] }
  end

  def hbi_payload
    if Condition::Translation.where(name: "Crohn's disease", id: last_tracked_condition_ids).any?
      HBI_PAYLOAD
    else
      [[HBI_PAYLOAD[0][0], HBI_PAYLOAD[0][1], false]]
    end
  end

  TRACKABLES.each do |type|
    titleized = type.titleize
    model = "Checkin::#{titleized}".constantize
    id_field = :"#{type}_id"
    last_tracked_ids_method = :"last_tracked_#{type}_ids"

    define_method(last_tracked_ids_method) do
      model.where(checkin_id: last_checkin&.id).distinct(id_field)
    end

    define_method(:"#{type.pluralize}_payload") do
      ids = model.where(:checkin_id.in => checkin_ids).distinct(id_field)

      "#{titleized}::Translation"
        .constantize
        .where(id_field => ids, :locale => I18n.locale)
        .pluck(id_field, :name)
        .map { |payload| payload << send(last_tracked_ids_method).include?(payload.first) }
    end
  end
end
