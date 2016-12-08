class FoodsRetriever
  attr_reader :scope, :occurrences, :current_user

  def initialize(scope, current_user=nil)
    fail ArgumentError unless [:most_popular, :most_recent].include?(scope)
    @scope = scope
    @current_user = current_user
  end

  def retrieve
    send scope
  end

  private

  def most_popular
    @occurrences = Checkin.collection.aggregate([
      # Step 1: have one entry per food id
      { "$unwind" => "$food_ids" },
      # Step 2: group by food id and count occurrences
      { "$group" => { _id: "$food_ids", count: { "$sum" => 1 } } },
      # Step 3: sort by occurrences, descending
      { "$sort" => { count: -1 } },
      # Step 4: limit to 10 results
      { "$limit" => 10 }
    ])
    food_ids = occurrences.map { |o| o['_id'] }
    Food.where(id: food_ids)
  end

  def most_recent
    checkin_foods = Checkin.collection.aggregate([
      # Step 1: filter by user
      { "$match" => { user_id: current_user.id } },
      # Step 2: have one entry per food id
      { "$unwind" => "$food_ids" },
      # Step 3: sort by checkin date, descending
      { "$sort" => { date: -1 } },
      # Step 4: limit to 10 results
      { "$limit" => 10 }
    ])
    food_ids = checkin_foods.map { |o| o['food_ids'] }
    Food.where(id: food_ids)
  end

end
