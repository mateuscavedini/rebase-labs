require './app/services/database_service'
require './app/repositories/base_repository'

class TestsRepository < BaseRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO tests (cpf, nome_paciente, email_paciente, data_nascimento_paciente,
                       endereco_rua_paciente, cidade_paciente, estado_paciente, crm_medico,
                       crm_medico_estado, nome_medico, email_medico, token_resultado_exame,
                       data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
  SQL

  def initialize(conn: nil)
    super(class_name: self.class, conn: conn)
  end

  def batch_insert(batch:, close_conn: true)
    super(batch: batch, insert_sql: INSERT_SQL, close_conn: close_conn)
  end
end
