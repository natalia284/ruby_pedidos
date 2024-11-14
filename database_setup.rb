require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  port: 5432, 
  username: 'natalia',
  password: '1234',
  database: 'banco'

)



