require './app/services/database_service'

class TestsRepository
  def initialize(database: DatabaseService)
    @conn = database.connection
  end

  def all
    result = @conn.exec 'SELECT * FROM tests'
    @conn.close

    result
  end
end
