# frozen-string-literal: true

require 'csv'
require 'sinatra'
require './app/services/exams_service'

class Server < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/../public'

  get '/hello' do
    'Server rodando!'
  end

  get '/exams/:token' do
    content_type :json
    ExamsService.new.fetch_by_token token: params['token']
  end

  get '/exams' do
    content_type :json
    ExamsService.new.fetch_all
  end

  get '/' do
    content_type 'text/html'
    File.open(File.join('public', 'index.html'))
  end
end
