class RankedEnumSerializer < ApplicationSerializer
  attributes :id, :name, :rank

  def name
    I18n.t "#{key}.#{object.id}"
  end

  protected

  def key
    object.class.name.underscore
  end
end
