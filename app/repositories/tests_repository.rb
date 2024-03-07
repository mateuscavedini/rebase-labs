require './app/services/database_service'

class TestsRepository
  INSERT_SQL = <<-SQL.freeze
    INSERT INTO tests (cpf, nome_paciente, email_paciente, data_nascimento_paciente,
                       endereco_rua_paciente, cidade_paciente, estado_paciente, crm_medico,
                       crm_medico_estado, nome_medico, email_medico, token_resultado_exame,
                       data_exame, tipo_exame, limites_tipo_exame, resultado_tipo_exame)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
  SQL

  def initialize(database: DatabaseService)
    @conn = database.connection
  end

  def all
    result = @conn.exec 'SELECT * FROM tests'
    @conn.close

    result
  end

  def batch_insert(batch)
    @conn.prepare 'prepared_test_insert', INSERT_SQL

    @conn.transaction do
      batch.map { |data| @conn.exec_prepared 'prepared_test_insert', data }
    end

    @conn.close
  end
end
