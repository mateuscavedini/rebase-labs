require 'pg'

class DatabaseService
  BASE_CONFIG = {
    host: 'postgres',
    port: 5432,
    user: 'postgres',
    password: 'postgres'
  }.freeze

  DB_CREATE_PATIENTS_TABLE = <<-SQL.freeze
    CREATE TABLE IF NOT EXISTS patients (
      cpf VARCHAR PRIMARY KEY,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL UNIQUE,
      birthday DATE NOT NULL,
      address VARCHAR NOT NULL,
      city VARCHAR NOT NULL,
      state VARCHAR NOT NULL
    );
  SQL

  DB_CREATE_DOCTORS_TABLE = <<-SQL.freeze
    CREATE TABLE IF NOT EXISTS doctors (
      crm VARCHAR NOT NULL,
      crm_state VARCHAR NOT NULL,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL,
      PRIMARY KEY (crm, crm_state)
    );
  SQL

  DB_CREATE_EXAMS_TABLE = <<-SQL.freeze
    CREATE TABLE IF NOT EXISTS exams (
      token VARCHAR PRIMARY KEY,
      date DATE,
      patient_cpf VARCHAR,
      doctor_crm VARCHAR,
      doctor_crm_state VARCHAR,
      FOREIGN KEY (patient_cpf) REFERENCES patients (cpf),
      FOREIGN KEY (doctor_crm, doctor_crm_state) REFERENCES doctors (crm, crm_state)
    );
  SQL

  DB_CREATE_TESTS_TABLE = <<-SQL.freeze
    CREATE TABLE IF NOT EXISTS tests (
      type VARCHAR,
      limits VARCHAR,
      result VARCHAR,
      exam_token VARCHAR,
      PRIMARY KEY (type, exam_token),
      FOREIGN KEY (exam_token) REFERENCES exams (token)
    );
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
      conn.exec 'DROP TABLE IF EXISTS exams'
      conn.exec 'DROP TABLE IF EXISTS doctors'
      conn.exec 'DROP TABLE IF EXISTS patients'
    end

    conn.exec DB_CREATE_PATIENTS_TABLE
    conn.exec DB_CREATE_DOCTORS_TABLE
    conn.exec DB_CREATE_EXAMS_TABLE
    conn.exec DB_CREATE_TESTS_TABLE

    conn.close
  end
end
