module Api
  module V1
    class PromotionRateSerializer < ApplicationSerializer
      attributes :id, :score, :feedback, :checkin_id
    end
  end
end
