class Dose
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :name

  def id
    Digest::SHA256.base64digest(name)
  end

end
