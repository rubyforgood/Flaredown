class ChartsPattern
  attr_accessor :start_at, :end_at, :pattern, :user, :checkins_with_weather
  attr_reader :used_color_ids

  COLOR_IDS = Flaredown::Colorable::IDS
  ADITIONAL_DAYS = 8

  TYPE_CHART = {
    line: %w[conditions symptoms],
    marker: %w[treatments tags foods],
    hbi: %w[harveyBradshawIndices],
    weather: %w[weathersMeasures]
  }.freeze

  SUBTYPE = {
    static: %i[line marker],
    dynamic: %i[hbi weather]
  }.freeze

  def initialize(options)
    @start_at = options[:start_at]
    @end_at = options[:end_at]
    @pattern = options[:pattern]
    @used_color_ids = []
    @checkins_with_weather = checkins.where(:weather_id.ne => nil)
  end

  def user
    @user ||= pattern.author
  end

  def checkins
    @checkins ||= user.checkins.order(date: :asc)
  end

  def scoped_checkins
    @scoped_checkins ||= checkins.by_date(start_at.to_date - ADITIONAL_DAYS.days, end_at.to_date + ADITIONAL_DAYS.days)
  end

  def chart_data
    @data ||=
      {
        pattern_id: pattern.id,
        pattern_name: pattern.name,
        author_email: user.email,

        series: pattern_includes.map do |chart|
          category = chart[:category]
          type = TYPE_CHART.select { |_, value| value.include?(category) }.keys&.first
          {
            type: type,
            subtype: SUBTYPE.select { |_, value| value.include? type }.keys&.first,
            label: chart[:label],
            category: category,
            color_id: get_color_id(chart),
            data: data(chart)
          }
        end
      }
  end

  def pattern_includes
    @pattern_includes ||= pattern.includes || []
  end

  def data(chart)
    category = chart[:category]
    id = chart[:id]

    if %w[conditions symptoms treatments].include? category
      static_trackables_coordinates(category, scoped_checkins.map(&:id), id)
    else
      health_factors_trackables_coordinate(category, scoped_checkins, id)
    end
  end

  def static_trackables_coordinates(category, checkin_ids, id)
    find_coordinates_by_checkin(category, checkin_ids, id)
      .sort! { |x, y| x[:x].to_time.to_i <=> y[:x].to_time.to_i }
  end

  def find_coordinates_by_checkin(category, checkin_ids, id)
    category_name = category.singularize

    "Checkin::#{category_name.camelize}".constantize.where(
      checkin_id: {'$in': checkin_ids},
      "#{category_name}_id": id
    ).map do |tr|
      coord = {x: tr.checkin.date, y: tr.value}
      coord[:is_taken] = tr.is_taken if category == "treatments"

      coord
    end.uniq
  end

  def health_factors_trackables_coordinate(category, selected_checkins, id)
    is_weather = %w[weathersMeasures].include? category

    trackables =
      if %w[foods tags].include? category
        selected_checkins.select { |checkin| checkin.send("#{category.singularize}_ids").include? id }
          .map { |checkin| {x: checkin.date} }.uniq
      elsif is_weather
        selected_checkins.select(&:weather).map { |checkin| {x: checkin.date, y: checkin.weather.send(id)} }
      else
        selected_checkins.select(&:harvey_bradshaw_index)
          .map { |checkin| {x: checkin.date, y: checkin.harvey_bradshaw_index.score} }
      end

    trackables.sort! { |x, y| x[:x].to_time.to_i <=> y[:x].to_time.to_i }
  end

  def get_color_id(chart)
    model_name = chart[:category].singularize.camelize

    color_id =
      if Tracking::TYPES.include? model_name
        user.trackings.where(trackable_type: model_name, trackable_id: chart[:id]).pluck(:color_id).compact.last
      end

    if color_id.present?
      used_color_ids << color_id

      return color_id
    end

    color_id = (COLOR_IDS - used_color_ids).shift
    used_color_ids << color_id

    color_id
  end
end
