module Checkin::Fiveable
  extend ActiveSupport::Concern

  included do
    field :value, type: Integer
    validates :value, inclusion: {in: (0..4), allow_blank: true}
  end
end
