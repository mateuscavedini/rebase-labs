require 'spec_helper'
require './app/models/test'
require 'csv'

describe Test do
  context '::new_from_row' do
    it 'deve instanciar novo teste a partir de uma linha csv' do
      rows = CSV.read './spec/support/csv/single_row_csv.csv', col_sep: ';', headers: true
      row = rows.first

      result = Test.new_from_row row

      expect(result.class).to eq Test
      expect(result.type).to eq 'hemácias'
      expect(result.limits).to eq '45-52'
      expect(result.result).to eq '97'
      expect(result.exam_token).to eq 'IQCZ17'
    end
  end
end
