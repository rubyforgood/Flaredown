class CountrySerializer < ApplicationSerializer
  attributes :id, :name

  def id
    object.alpha2
  end

  def name
    object.translation(I18n.locale.to_s)
  end
end
