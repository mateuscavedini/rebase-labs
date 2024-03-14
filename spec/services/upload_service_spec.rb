require 'spec_helper'
require './app/services/upload_service'

describe UploadService do
  context '::read' do
    it 'deve ler o conteúdo do arquivo csv' do
      uploaded_file = File.open(File.join('spec/support/csv', 'upload_test_file.csv'))

      result = UploadService.read file: uploaded_file

      expect(result.size).to eq 130
      expect(result['cpf']).to include '711.706.040-99'
      expect(result['cpf']).to include '575.918.000-27'
      expect(result['cpf']).to include '741.560.520-95'
    end
  end

  context '::import' do
    it 'deve salvar conteúdo do arquivo csv no banco' do
      uploaded_file = File.open(File.join('spec/support/csv', 'upload_test_file.csv'))

      UploadService.import file: uploaded_file
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
