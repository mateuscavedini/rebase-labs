require 'sinatra'

class Server < Sinatra::Base
  get '/' do
    'teste'
  end
end
