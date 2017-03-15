class OracleRequest
  include Mongoid::Document

  field :age, type: Integer

  field :sex_id, type: String

  field :responce,    type: Array, default: []
  field :symptom_ids, type: Array, default: []

  def sex
    @_sex ||= Sex.find(sex_id)
  end

  def symptoms
    @_symptoms ||= Symptom.where(id: symptom_ids)
  end
end
