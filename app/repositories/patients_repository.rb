class PatientsRepository < BaseRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO patients (cpf, name, email, birthday, address, city, state)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    ON CONFLICT (cpf) DO NOTHING;
  SQL

  def initialize(conn: nil)
    super(class_name: self.class, conn: conn)
  end

  def batch_insert(batch:, close_conn: true)
    super(batch: batch, insert_sql: INSERT_SQL, close_conn: close_conn)
  end
end
