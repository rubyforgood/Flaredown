module PatternExtender
  attr_accessor :start_at, :end_at, :pattern, :user, :chart_data

  def form_chart_data(options)
    @start_at, @end_at = options[:start_at], options[:end_at]
    @pattern, @user = options[:pattern], options[:user]

    @chart_data = ChartsPattern.new(start_at: start_at, end_at: end_at, pattern: pattern, user: user).chart_data

    chart_data.merge({ used_color_ids: self.used_color_ids})
  end

  def used_color_ids
    chart_data[:series].map { |item| item[:color_id] }.compact
  end
end
