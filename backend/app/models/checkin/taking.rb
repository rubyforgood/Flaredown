class Checkin::Taking
  include Mongoid::Document
  include Checkin::Timeable

  field :dose, type: String

  belongs_to :treatment, class_name: 'Checkin::Treatment', index: true
end
