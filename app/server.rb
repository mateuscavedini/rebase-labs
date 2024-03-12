# frozen-string-literal: true

require 'csv'
require 'sinatra'
require './app/services/exams_service'

class Server < Sinatra::Base
  get '/' do
    'Server rodando!'
  end

  get '/exams' do
    content_type :json
    ExamsService.new.fetch_all
  end
end
