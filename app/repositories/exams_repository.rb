require './app/repositories/base_repository'

class ExamsRepository < BaseRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO exams (token, date, patient_cpf, doctor_crm, doctor_crm_state)
    VALUES ($1, $2, $3, $4, $5)
    ON CONFLICT (token) DO NOTHING;
  SQL

  def initialize(conn: nil)
    super(class_name: self.class, conn: conn)
  end

  def batch_insert(batch:, close_conn: true)
    super(batch: batch, insert_sql: INSERT_SQL, close_conn: close_conn)
  end
end
