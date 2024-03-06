# frozen-string-literal: true

require 'rake'
require 'pg'
require 'csv'
require './app/services/database_service'

namespace :db do
  task :init do
    puts '===== PREPARANDO BANCO DE DADOS... ====='

    conn = DatabaseService.connection

    db_init = <<-SQL
      CREATE TABLE IF NOT EXISTS exames (
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

    conn.exec 'DROP TABLE IF EXISTS exames'
    conn.exec db_init

    puts '===== BANCO DE DADOS PRONTO! ====='
  end

  task import: [:init] do
    conn = DatabaseService.connection

    rows = CSV.read './data/data.csv', col_sep: ';', headers: true

    db_insert = <<-SQL
      INSERT INTO exames (
        cpf,
        nome_paciente,
        email_paciente,
        data_nascimento_paciente,
        endereco_rua_paciente,
        cidade_paciente,
        estado_paciente,
        crm_medico,
        crm_medico_estado,
        nome_medico,
        email_medico,
        token_resultado_exame,
        data_exame,
        tipo_exame,
        limites_tipo_exame,
        resultado_tipo_exame
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
    SQL

    puts '===== IMPORTANDO DADOS... ====='

    rows.map do |row|
      conn.exec db_insert, row.fields
    end

    puts '===== IMPORTAÇÃO FINALIZADA! ====='
  end
end
