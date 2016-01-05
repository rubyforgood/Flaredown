class SessionSerializer < ActiveModel::Serializer
  attributes :id

  def id
    1
  end

end
