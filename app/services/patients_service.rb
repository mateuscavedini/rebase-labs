require './app/repositories/patients_repository'

class PatientsService
  def initialize(repository: PatientsRepository, conn: nil)
    @repository = repository.new conn: conn
  end

  def batch_insert(batch:, close_conn: true)
    values = batch.map(&:attr_values)
    @repository.batch_insert batch: values, close_conn: close_conn
  end
end
