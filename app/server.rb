# frozen-string-literal: true

require 'csv'
require 'sinatra'
require './app/services/tests_service'

class Server < Sinatra::Base
  get '/' do
    'Server rodando!'
  end

  get '/tests' do
    content_type :json
    TestsService.new.fetch_all
  end
end
