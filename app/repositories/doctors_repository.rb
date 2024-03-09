class DoctorsRepository < BaseRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO doctors (crm, crm_state, name, email)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (crm, crm_state) DO NOTHING;
  SQL

  def initialize(conn: nil)
    super(class_name: self.class, conn: conn)
  end

  def batch_insert(batch:, close_conn: true)
    super(batch: batch, insert_sql: INSERT_SQL, close_conn: close_conn)
  end
end
