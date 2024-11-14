require_relative 'database_setup'
require 'active_record'

# Caminho das migrations
migrations_path = File.expand_path('db/migrate', __dir__)

# Executar todas as migrations
ActiveRecord::MigrationContext.new(
  migrations_path, 
  ActiveRecord::Base.connection.schema_migration
).up

puts "Migrações aplicadas com sucesso!"