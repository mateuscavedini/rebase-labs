require './app/repositories/exams_repository'

class ExamsService
  def initialize(repository: ExamsRepository, conn: nil)
    @repository = repository.new conn: conn
  end

  def fetch_all(close_conn: true)
    @repository.all(close_conn: close_conn).map do |row|
      {
        token: row['token'],
        date: row['date'],
        patient: JSON.parse(row['patient']),
        doctor: JSON.parse(row['doctor']),
        tests: JSON.parse(row['tests'])
      }
    end.to_json
  end

  def batch_insert(batch:, close_conn: true)
    values = batch.map(&:attr_values)
    @repository.batch_insert batch: values, close_conn: close_conn
  end
end
