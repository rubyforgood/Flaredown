class TagsRetriever
  attr_reader :scope, :occurrences

  def initialize(scope)
    fail ArgumentError unless [:most_popular, :most_recent].include?(scope)
    @scope = scope
  end

  def retrieve
    send scope
  end

  private

  def most_popular
    @occurrences = Checkin.collection.aggregate([
      # Step 1: have one entry per tag id
      { "$unwind" => "$tag_ids" },
      # Step 2: group by tag id and count occurrences
      { "$group" => { _id: "$tag_ids", count: { "$sum" => 1 } } },
      # Step 3: sort by occurrences, descending
      { "$sort" => { count:-1 } },
      # Step 4: limit to 10 results
      { "$limit" => 10 }
    ])
    tag_ids = occurrences.map { |o| o['_id'] }
    Tag.where(id: tag_ids)
  end

  def most_recent
    # TODO
    puts __method__
  end

end
