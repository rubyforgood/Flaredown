class PromotionRate
  include Mongoid::Document
  include Mongoid::Timestamps

  MIN_SCORE_FOR_REVIWS = 8

  field :date, type: Date
  field :score, type: Integer
  field :feedback, type: String
  field :encrypted_user_id, type: String, encrypted: {type: :integer}
  field :user_created_at, type: Date

  belongs_to :checkin, index: true

  index(date: 1, encrypted_user_id: 1)

  validates :checkin, presence: true
  validates :checkin_id, uniqueness: true

  before_create :set_date_and_user_id

  # '17-09-2017'
  def self.group_by_score_and_date(start_str, end_str)
    start_day = start_str.to_date
    end_day = end_str.to_date

    PromotionRate.collection.aggregate(
      [
        {"$match": {
          date: {
            "$gte": start_day,
            "$lte": end_day
          }
        }},
        "$group": {_id: "$score", count: {"$sum": 1}}
      ]
    )
  end

  # '17-09-2017'
  def self.filter_low_scores_by_date(start_str, end_str)
    start_day = start_str.to_date
    end_day = end_str.to_date

    PromotionRate.collection.aggregate(
      [
        {"$match": {
          score: {
            "$lte": MIN_SCORE_FOR_REVIWS
          },
          date: {
            "$gte": start_day,
            "$lte": end_day
          }
        }}
      ]
    )
  end

  protected

  def set_date_and_user_id
    self.date = checkin.date
    self.encrypted_user_id = checkin.encrypted_user_id
  end
end
