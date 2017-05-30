class OracleRequestWithTokenSerializer < OracleRequestSerializer
  self.root = :oracle_request

  attributes :token

  def can_edit
    true
  end
end
