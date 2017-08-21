class Position < ActiveRecord::Base
  validates :postal_code, presence: true
  validate :geocoder_position_present

  before_create :set_location_name

  def set_location_name
    state = geocoder_position.state || geocoder_position.province

    self.location_name = [geocoder_position.city, state, geocoder_position.country].join(', ')
    self.latitude = geocoder_position.latitude
    self.longitude = geocoder_position.longitude
  end

  protected

  def geocoder_position_present
    errors.add(:postal_code, "No coordinates found for postal_code #{self.postal_code}}") if geocoder_position.blank?
  end

  def geocoder_position
    @geocoder_position ||= Geocoder.search(self.postal_code).first
  end
end
