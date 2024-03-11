require './app/repositories/tests_repository'

class TestsService
  def initialize(repository: TestsRepository, conn: nil)
    @repository = repository.new conn: conn
  end

  def fetch_all(close_conn: true)
    @repository.all(close_conn: close_conn).to_a.to_json
  end

  def batch_insert(batch:, close_conn: true)
    values = batch.map { |obj| obj.attr_values[1..] }
    @repository.batch_insert batch: values, close_conn: close_conn
  end
end
