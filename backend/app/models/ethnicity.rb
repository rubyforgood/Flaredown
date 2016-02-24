class Ethnicity < RankedEnum
  class << self
    def all_ids
      %w( latino white east_asian south_asian black oceanian
          middle_eastern native_american african other not_sure )
    end
  end
end
