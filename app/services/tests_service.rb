require './app/repositories/tests_repository'

class TestsService
  def initialize(repository: TestsRepository, conn: nil)
    @repository = repository.new conn: conn
  end

  def fetch_all(close_conn: true)
    @repository.all(close_conn: close_conn).to_a.to_json
  end

  def batch_insert(batch:, close_conn: true)
    @repository.batch_insert(batch: batch, close_conn: close_conn)
  end
end
