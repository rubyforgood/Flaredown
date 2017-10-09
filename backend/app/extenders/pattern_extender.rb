module PatternExtender
  attr_accessor :start_at, :end_at, :pattern, :user

  def form_chart_data(options)
    @start_at, @end_at = options[:start_at], options[:end_at]
    @pattern, @user = options[:pattern], options[:user]

    ChartsPattern.new(start_at: start_at, end_at: end_at, pattern: pattern, user: User.first).chart_data
  end
end
