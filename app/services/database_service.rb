require 'pg'

class DatabaseService
  BASE_CONFIG = {
    host: 'postgres',
    port: 5432,
    user: 'postgres',
    password: 'postgres'
  }.freeze

  DB_CREATE_TESTS_TABLE = <<-SQL.freeze
    CREATE TABLE IF NOT EXISTS tests (
      id SERIAL PRIMARY KEY,
      cpf VARCHAR,
      nome_paciente VARCHAR,
      email_paciente VARCHAR,
      data_nascimento_paciente DATE,
      endereco_rua_paciente VARCHAR,
      cidade_paciente VARCHAR,
      estado_paciente VARCHAR,
      crm_medico VARCHAR,
      crm_medico_estado VARCHAR,
      nome_medico VARCHAR,
      email_medico VARCHAR,
      token_resultado_exame VARCHAR,
      data_exame DATE,
      tipo_exame VARCHAR,
      limites_tipo_exame VARCHAR,
      resultado_tipo_exame VARCHAR
    )
  SQL

  def self.connection
    dbname = ENV['RACK_ENV'].eql?('test') ? 'postgres_test' : 'postgres'

    db_config = {
      dbname: dbname
    }.merge BASE_CONFIG

    PG.connect db_config
  end

  def self.setup
    conn = connection

    unless ENV['RACK_ENV'].eql? 'test'
      conn.exec 'DROP DATABASE IF EXISTS postgres_test'
      conn.exec 'CREATE DATABASE postgres_test'
      conn.exec 'DROP TABLE IF EXISTS tests'
    end

    conn.exec DB_CREATE_TESTS_TABLE

    conn.close
  end
end
