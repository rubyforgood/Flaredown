module Checkin::Timeable
  extend ActiveSupport::Concern

  included do
    field :time_of_day, type: Integer  # minutes from 00:00
    validates :time_of_day, inclusion: { in: (0..1440) }, if: 'time_of_day.present?'
  end

end
