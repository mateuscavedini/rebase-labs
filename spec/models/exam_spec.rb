require 'spec_helper'
require './app/models/exam'
require 'csv'

describe Exam do
  context '::new_from_row' do
    it 'deve instanciar novo exame a partir de uma linha csv' do
      rows = CSV.read './spec/support/csv/single_row_csv.csv', col_sep: ';', headers: true
      row = rows.first

      result = Exam.new_from_row row

      expect(result.class).to eq Exam
      expect(result.token).to eq 'IQCZ17'
      expect(result.date).to eq '2021-08-05'
      expect(result.patient_cpf).to eq '048.973.170-88'
      expect(result.doctor_crm).to eq 'B000BJ20J4'
      expect(result.doctor_crm_state).to eq 'PI'
    end
  end
end
