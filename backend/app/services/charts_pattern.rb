class ChartsPattern
  attr_accessor :start_at, :end_at, :pattern, :user

  TYPE_CHART = {
    line: %w(conditions symptoms),
    marker: %w(treatments tags foods),
    hbi: %w(harveyBradshawIndices),
    weather: %w(weathersMeasures)
  }.freeze

  SUBTYPE = {
    static: %i(line marker),
    dynamic: %i(hbi weather)
  }.freeze

  def initialize(options)
    @start_at = options[:start_at]
    @end_at   = options[:end_at]
    @pattern  = options[:pattern]
    @user     = options[:user]
  end

  def includes
    @includes ||=
      pattern_includes
        .map { |hash| hash.slice(:category, :id) }
        .group_by { |hash| hash[:category] }
        .each_with_object({}) { |obj, memo| memo[obj[0]] = obj[1].group_by { |i| i[:id] }.keys }
  end

  def checkins
    @checkins ||= user.checkins.by_date(start_at.to_date, end_at.to_date).map do |checkin|
      checkin.includes = includes

      checkin
    end
  end

  def chart_data
    @data ||=
      {
        pattern_id: pattern.id,
        pattern_name: pattern.name,

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
    @pattern_includes ||= pattern.includes
  end

  def data(chart)
    category = chart[:category]
    id = chart[:id]

    res =
      if %w(conditions symptoms treatments).include? category
        static_trackables_coordinates(category, checkins, id)
      else
        health_factors_trackables_coordinate(category, checkins, id)
      end

    res.sort { |x, y| x[:x].to_time.to_i <=> y[:x].to_time.to_i }
  end

  def static_trackables_coordinates(category, checkins, id)
    category_name = category.singularize

    "Checkin::#{category_name.camelize}".constantize.where(
      checkin_id: { '$in': checkins.map(&:id) },
      "#{category_name}_id": id
    ).map { |tr| { x: tr.checkin.date, y: tr.value || 0 } }.uniq
  end

  def health_factors_trackables_coordinate(category, checkins, id)
    if %w(foods tags).include? category
      checkins.select { |checkin| checkin.send("#{category.singularize}_ids").include? id }
        .map { |checkin| { x: checkin.date } }.uniq
    elsif %w(weathersMeasures).include? category
      checkins.select(&:weather).map { |checkin| { x: checkin.date, y: checkin.weather.send(id) } }
    else
      checkins.select(&:harvey_bradshaw_index)
        .map { |checkin| { x: checkin.date, y: checkin.harvey_bradshaw_index.score } }
    end
  end

  def get_color_id(chart)
    model_name = chart[:category].singularize.camelize

    Tracking.where(user_id: user.id, trackable_type: model_name, trackable_id: chart[:id])
      .active_in_range(start_at.to_date, end_at.to_date).map(&:color_id).compact.last
  end
end
