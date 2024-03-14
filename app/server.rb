# frozen-string-literal: true

require 'csv'
require 'sinatra'
require './app/services/exams_service'
require './app/services/upload_service'

class Server < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + '/../public'

  get '/hello' do
    'Server rodando!'
  end

  get '/exams/:token' do
    content_type :json
    ExamsService.new.fetch_by_token token: params[:token]
  rescue PG::Error
    status 500
    { errors: ['Erro interno de servidor'] }.to_json
  rescue StandardError
    status 404
    { errors: ['Exame não encontrado'] }.to_json
  end

  get '/exams' do
    content_type :json
    status 200
    ExamsService.new.fetch_all
  end

  post '/upload' do
    content_type :json

    if params[:file].eql? 'undefined'
      status 422
      return { errors: ['Insira um arquivo válido'] }.to_json
    end

    tempfile = params[:file][:tempfile]
    UploadService.import file: tempfile

    status 201
    { message: 'Dados salvos com sucesso!' }.to_json
  rescue CSV::MalformedCSVError
    status 422
    { errors: ['Erro ao ler o arquivo'] }.to_json
  rescue PG::Error
    status 500
    { errors: ['Erro interno de servidor'] }.to_json
  end

  get '/' do
    content_type 'text/html'
    File.open(File.join('public', 'index.html'))
  end

end
