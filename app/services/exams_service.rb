require './app/repositories/exams_repository'

class ExamsService
  def initialize(repository: ExamsRepository, conn: nil)
    @repository = repository.new conn: conn
  end

  def batch_insert(batch:, close_conn: true)
    values = batch.map(&:attr_values)
    @repository.batch_insert batch: values, close_conn: close_conn
  end
end
