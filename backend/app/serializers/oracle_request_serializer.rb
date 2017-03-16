class OracleRequestSerializer < ApplicationSerializer
  attributes :id, :age, :sex_id, :symptom_ids, :responce

  has_one :sex, embed_in_root: true
  has_many :symptoms, embed_in_root: true
end
