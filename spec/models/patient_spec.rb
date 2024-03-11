require 'spec_helper'
require './app/models/patient'
require 'csv'

describe Patient do
  context '::new_from_row' do
    it 'deve instanciar um paciente a partir de uma linha csv' do
      rows = CSV.read './spec/support/csv/single_row_csv.csv', col_sep: ';', headers: true
      row = rows.first

      result = Patient.new_from_row row

      expect(result.class).to eq Patient
      expect(result.cpf).to eq '048.973.170-88'
      expect(result.name).to eq 'Emilly Batista Neto'
      expect(result.email).to eq 'gerald.crona@ebert-quigley.com'
      expect(result.birthday).to eq '2001-03-11'
      expect(result.address).to eq '165 Rua Rafaela'
      expect(result.city).to eq 'Ituverava'
      expect(result.state).to eq 'Alagoas'
    end
  end
end
