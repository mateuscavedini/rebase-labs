# frozen-string-literal: true

require 'csv'
require 'sinatra'
require 'pg'

class Server < Sinatra::Base
  get '/' do
    'Server rodando!'
  end

  get '/tests' do
    content_type :json

    conn = PG.connect dbname: 'postgres',
                      host: 'postgres',
                      port: 5432,
                      user: 'postgres',
                      password: 'postgres'

    conn.exec('SELECT * FROM exames;').to_a.to_json
  end
end
