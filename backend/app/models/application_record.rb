class ApplicationRecord < ActiveRecord::Base
  if ENV['DEPENDENCIES_NEXT']
    primary_abstract_class
  else
    self.abstract_class = true
  end
end
