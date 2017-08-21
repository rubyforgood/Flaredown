class Weather < ActiveRecord::Base
  validates :date, uniqueness: { scope: :position_id }, if: Proc.new { position_id.present? }
  belongs_to :position
end
