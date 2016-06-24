class Dose
  include ActiveModel::Model, ActiveModel::Serialization

  attr_accessor :name

  def id
    name.parameterize
  end

end
