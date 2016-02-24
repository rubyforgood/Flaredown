class RankedEnumSerializer < ApplicationSerializer
  attributes :id, :name, :rank

  def name
    I18n.t "#{object.class.name.underscore}.#{object.id}"
  end
end
