require 'spec_helper'

describe 'Rebase Labs API' do
  context 'GET /' do
    it 'deve exibir mensagem inicial' do
      get '/'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'Server rodando!'
    end
  end

  context 'GET /tests' do
    it 'deve retornar dados do csv' do
      get '/tests'

      json_body = JSON.parse last_response.body

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(json_body[0]['nome_paciente']).to eq 'Emilly Batista Neto'
      expect(json_body[0]['nome_medico']).to eq 'Maria Luiza Pires'
      expect(json_body[0]['token_resultado_exame']).to eq 'IQCZ17'
    end
  end
end
