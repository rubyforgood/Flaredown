class OracleRequest
  include Mongoid::Document

  field :age, type: Integer

  field :token, type: String
  field :sex_id, type: String

  field :responce, type: Array, default: []
  field :symptom_ids, type: Array, default: []

  index(token: 1)

  def sex
    @_sex ||= Sex.find(sex_id)
  end

  def symptoms
    @_symptoms ||= Symptom.where(id: symptom_ids)
  end

  def can_edit?(oracle_token)
    token == oracle_token
  end
end
