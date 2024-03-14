require './app/repositories/tests_repository'

class TestsService
  def initialize(repository: TestsRepository, conn: nil)
    @repository = repository.new conn: conn
  end

  def batch_insert(batch:, close_conn: true)
    values = batch.map { |obj| obj.attr_values }
    @repository.batch_insert batch: values, close_conn: close_conn
  end
end
