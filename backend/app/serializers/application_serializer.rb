class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :created_at, :updated_at

  alias current_user scope

  def id
    object.try :id
  end

  def created_at
    object.try :created_at
  end

  def updated_at
    object.try :updated_at
  end
end
