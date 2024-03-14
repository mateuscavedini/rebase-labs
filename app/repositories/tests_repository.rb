require './app/repositories/base_repository'

class TestsRepository < BaseRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO tests (type, limits, result, exam_token)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (type, exam_token) DO NOTHING;
  SQL

  def initialize(conn: nil)
    super(class_name: self.class, conn: conn)
  end

  def batch_insert(batch:, close_conn: true)
    super(batch: batch, insert_sql: INSERT_SQL, close_conn: close_conn)
  end
end
