# frozen-string-literal: true

require 'csv'
require 'sinatra'
require 'pg'
require './app/services/database_service'

class Server < Sinatra::Base
  get '/' do
    'Server rodando!'
  end

  get '/tests' do
    content_type :json

    conn = DatabaseService.connection

    conn.exec('SELECT * FROM exames;').to_a.to_json
  end
end
