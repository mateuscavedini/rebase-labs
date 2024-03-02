require 'csv'
require 'sinatra'

class Server < Sinatra::Base
  get '/' do
    'Server rodando!'
  end

  get '/tests' do
    content_type :json

    rows = CSV.read './data/data.csv', col_sep: ';'

    columns = rows.shift

    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end.to_json
  end
end
