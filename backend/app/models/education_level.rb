class EducationLevel < RankedEnum
  class << self
    def all_ids
      %w[less_than_hi_school hi_school college_degree bachelors_degree advanced_degree]
    end
  end
end
