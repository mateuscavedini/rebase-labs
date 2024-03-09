require 'spec_helper'
require './app/repositories/doctors_repository'

describe DoctorsRepository do
  context '#batch_insert' do
    it 'deve inserir médicos no banco' do
      repository = DoctorsRepository.new conn: @conn
      ana = ['B000A7CDX4', 'SP', 'Ana da Silva', 'ana@email.com']
      pedro = ['B000AR99QO', 'SC', 'Pedro Lopes', 'pedro@email.com']
      joao = ['B0000DHDOF', 'MA', 'João Lima', 'joao@email.com']
      batch  = [ana, pedro, joao]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM doctors;'

      expect(result.num_tuples).to eq 3
      expect(result.values[0]).to eq ana
      expect(result.values[1]).to eq pedro
      expect(result.values[2]).to eq joao
    end

    it 'não deve inserir médicos com crm já registrado' do
      repository = DoctorsRepository.new conn: @conn
      ana = ['B000A7CDX4', 'SP', 'Ana da Silva', 'ana@email.com']
      pedro = ['B000A7CDX4', 'SP', 'Pedro Lopes', 'pedro@email.com']
      joao = ['B0000DHDOF', 'MA', 'João Lima', 'joao@email.com']
      batch = [ana, pedro, joao]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM doctors;'

      expect(result.num_tuples).to eq 2
      expect(result.values[0]).to eq ana
      expect(result.values[1]).to eq joao
      expect(result.values).not_to include pedro
    end

    it 'não insere nenhum médico em caso de erro' do
      repository = DoctorsRepository.new conn: @conn
      ana = ['B000A7CDX4', 'SP', 'Ana da Silva', 'ana@email.com']
      pedro = ['B000AR99QO', 'SC', 'Pedro Lopes', 'pedro@email.com']
      joao = ['B0000DHDOF', 'MA', 'João Lima', 'joao@email.com']
      batch = [ana, pedro, joao]

      allow(@conn).to receive(:exec_prepared).and_call_original
      allow(@conn).to receive(:exec_prepared).with('prepared_insert', joao).and_raise(PG::Error)
      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM doctors;'

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end
end
