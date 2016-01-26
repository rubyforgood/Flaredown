class SexSerializer < ApplicationSerializer
  attributes :id, :name, :rank

  def name
    I18n.t "sex.#{object.id}"
  end
end
