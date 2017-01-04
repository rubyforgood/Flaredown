class Weather < ActiveRecord::Base
  validates :date, uniqueness: { scope: :postal_code }
end
