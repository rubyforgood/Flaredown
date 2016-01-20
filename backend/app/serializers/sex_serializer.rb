class SexSerializer < ApplicationSerializer
  attributes :id, :name

  def name
    I18n.t "sex.#{object.id}"
  end
end
