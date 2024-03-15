require 'spec_helper'
require './app/services/upload_service'

describe UploadService do
  context '::import' do
    it 'deve salvar conteúdo do arquivo csv no banco' do

      rows = CSV.read 'spec/support/csv/upload_test_file.csv', col_sep: ';'

      UploadService.import rows: rows
      added_patients = @conn.exec 'SELECT * FROM patients;'
      added_doctors = @conn.exec 'SELECT * FROM doctors;'
      added_exams = @conn.exec 'SELECT * FROM exams;'
      added_tests = @conn.exec 'SELECT * FROM tests;'

      expect(added_patients.num_tuples).to eq 10
      expect(added_doctors.num_tuples).to eq 10
      expect(added_exams.num_tuples).to eq 10
      expect(added_tests.num_tuples).to eq 130
    end
  end
end
