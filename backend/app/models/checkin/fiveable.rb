module Checkin::Fiveable
  extend ActiveSupport::Concern

  included do
    field :value, type: Integer
    validates :value, inclusion: {in: (0..4)}, if: "value.present?"
  end
end
