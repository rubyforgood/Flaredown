module Checkin::Trackable
  extend ActiveSupport::Concern

  included do
    #
    # Fields
    #
    field :position, type: Integer
    field :color_id, type: String

    #
    # Relations
    #
    belongs_to :checkin, index: true
  end
end
