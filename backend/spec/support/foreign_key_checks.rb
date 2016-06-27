module ForeignKeyChecks
  extend ActiveSupport::Concern

  def disable_foreign_key_checks(table)
    ActiveRecord::Base.connection.execute("ALTER TABLE #{table} DISABLE TRIGGER ALL;")
  end

  def enable_foreign_key_checks(table)
    ActiveRecord::Base.connection.execute("ALTER TABLE #{table} ENABLE TRIGGER ALL;")
  end
end

RSpec.configure do |config|
  config.include ForeignKeyChecks, type: :model
end
