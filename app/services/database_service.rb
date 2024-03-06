require 'pg'

class DatabaseService
  DB_CONFIG = {
    dbname: 'postgres',
    host: 'postgres',
    port: 5432,
    user: 'postgres',
    password: 'postgres'
  }

  def self.connection
    PG.connect DB_CONFIG
  end
end
