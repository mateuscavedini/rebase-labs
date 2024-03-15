require 'spec_helper'
require 'csv'
require './app/jobs/import_csv_job'

describe ImportCsvJob do
  context '#perform' do
    it 'deve importar dados do csv para o banco de dados' do
      rows = CSV.read 'spec/support/csv/upload_test_file.csv', col_sep: ';'
      
      ImportCsvJob.perform_sync rows
      added_patients = @conn.exec('SELECT * FROM patients;').num_tuples
      added_doctors = @conn.exec('SELECT * FROM doctors;').num_tuples
      added_exams = @conn.exec('SELECT * FROM exams;').num_tuples
      added_tests = @conn.exec('SELECT * FROM tests;').num_tuples

      expect(added_patients).to eq 10
      expect(added_doctors).to eq 10
      expect(added_exams).to eq 10
      expect(added_tests).to eq 130
    end
  end
end
