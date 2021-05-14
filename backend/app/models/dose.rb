class Dose
  include ActiveModel::Serialization
  include ActiveModel::Model

  attr_accessor :name

  def id
    name.parameterize
  end
end
