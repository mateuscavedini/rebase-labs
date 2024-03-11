# frozen-string-literal: true

require 'rake'
require 'csv'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam'
require './app/models/test'
require './app/services/database_service'
require './app/services/patients_service'
require './app/services/doctors_service'
require './app/services/exams_service'
require './app/services/tests_service'

namespace :db do
  task :init do
    puts '----> PREPARANDO BANCO DE DADOS...'

    DatabaseService.setup

    puts '----> BANCO DE DADOS PRONTO!'
  end

  task import: [:init] do
    conn = DatabaseService.connection
    patients = []
    doctors = []
    exams = []
    tests = []

    puts '----> IMPORTANDO DADOS...'

    rows = CSV.read './data/data.csv', col_sep: ';', headers: true
    rows.each do |row|
      patients << Patient.new_from_row(row)
      doctors << Doctor.new_from_row(row)
      exams << Exam.new_from_row(row)
      tests << Test.new_from_row(row)
    end

    PatientsService.new(conn: conn).batch_insert batch: patients, close_conn: false
    DoctorsService.new(conn: conn).batch_insert batch: doctors, close_conn: false
    ExamsService.new(conn: conn).batch_insert batch: exams, close_conn: false
    TestsService.new(conn: conn).batch_insert batch: tests, close_conn: false

    conn.close

    puts '----> IMPORTAÇÃO FINALIZADA!'
  end
end
