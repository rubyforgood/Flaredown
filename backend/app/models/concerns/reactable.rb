module Reactable
  extend ActiveSupport::Concern

  included do
    has_many :reactions, as: :reactable
  end
end
