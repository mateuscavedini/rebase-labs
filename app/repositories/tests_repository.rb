require './app/services/database_service'

class TestsRepository
  def initialize(database: DatabaseService)
    @conn = database.connection
  end

  def all
    @conn.exec 'SELECT * FROM tests'
  end
end
