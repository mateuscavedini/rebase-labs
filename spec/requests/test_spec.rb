require 'spec_helper'

describe 'Rebase Labs API' do
  context 'GET /' do
    it 'deve retornar mensagem de teste' do
      get '/'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'teste'
    end
  end
end
