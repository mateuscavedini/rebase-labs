require './app/repositories/base_repository'

class ExamsRepository < BaseRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO exams (token, date, patient_cpf, doctor_crm, doctor_crm_state)
    VALUES ($1, $2, $3, $4, $5)
    ON CONFLICT (token) DO NOTHING;
  SQL

  JOINED_SELECT_SQL = <<-SQL.freeze
    SELECT e.token, e.date, json_build_object('name', p.name, 'cpf', p.cpf) AS patient,
           json_build_object('name', d.name, 'crm', d.crm, 'crm_state', d.crm_state) AS doctor
    FROM exams e
    JOIN patients p ON e.patient_cpf = p.cpf
    JOIN doctors d ON e.doctor_crm = d.crm AND e.doctor_crm_state = d.crm_state
    GROUP BY e.token, e.date, p.name, p.cpf, d.name, d.crm, d.crm_state
    ORDER BY e.date DESC;
  SQL

  def initialize(conn: nil)
    super(class_name: self.class, conn: conn)
  end

  def all(close_conn: true)
    result = @conn.exec JOINED_SELECT_SQL

    @conn.close if close_conn

    result
  end

  def batch_insert(batch:, close_conn: true)
    super(batch: batch, insert_sql: INSERT_SQL, close_conn: close_conn)
  end
end
