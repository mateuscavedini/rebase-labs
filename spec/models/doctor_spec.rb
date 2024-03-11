require 'spec_helper'
require './app/models/doctor'
require 'csv'

describe Doctor do
  context '::new_from_row' do
    it 'instacia novo médico a partir de uma linha csv' do
      rows = CSV.read './spec/support/csv/single_row_csv.csv', col_sep: ';', headers: true
      row = rows.first

      result = Doctor.new_from_row row

      expect(result.class).to eq Doctor
      expect(result.name).to eq 'Maria Luiza Pires'
      expect(result.email).to eq 'denna@wisozk.biz'
      expect(result.crm).to eq 'B000BJ20J4'
      expect(result.crm_state).to eq 'PI'
    end
  end
end
