require './app/services/database_service'

class BaseRepository
  def initialize(class_name:, database: DatabaseService, conn: nil)
    @table_name = class_name.to_s.sub('Repository', '').downcase
    @conn = conn || database.connection
  end

  def batch_insert(batch:, insert_sql:, close_conn: true)
    @conn.prepare "prepared_#{@table_name}_insert", insert_sql

    begin
      @conn.transaction do
        batch.map { |data| @conn.exec_prepared "prepared_#{@table_name}_insert", data }
      end
    rescue PG::Error
      puts 'Erro na inserção dos dados! Rolled back!'
    end

    @conn.close if close_conn
  end
end
