require 'spec_helper'
require './app/repositories/doctors_repository'
require './app/models/doctor'

describe DoctorsRepository do
  context '#batch_insert' do
    it 'deve inserir médicos no banco' do
      repository = DoctorsRepository.new conn: @conn
      ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                       name: 'Ana da Silva', email: 'ana@email.com'
      ana_values = ana.attr_values
      pedro = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                         name: 'Pedro Lopes', email: 'pedro@email.com'
      pedro_values = pedro.attr_values
      joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                        name: 'João Lima', email: 'joao@email.com'
      joao_values = joao.attr_values
      batch = [ana_values, pedro_values, joao_values]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM doctors;'

      expect(result.num_tuples).to eq 3
      expect(result.values[0]).to eq ana_values
      expect(result.values[1]).to eq pedro_values
      expect(result.values[2]).to eq joao_values
    end

    it 'não deve inserir médicos com crm já registrado' do
      repository = DoctorsRepository.new conn: @conn
      ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                       name: 'Ana da Silva', email: 'ana@email.com'
      ana_values = ana.attr_values
      pedro = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                         name: 'Pedro Lopes', email: 'pedro@email.com'
      pedro_values = pedro.attr_values
      joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                        name: 'João Lima', email: 'joao@email.com'
      joao_values = joao.attr_values
      batch = [ana_values, pedro_values, joao_values]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM doctors;'

      expect(result.num_tuples).to eq 2
      expect(result.values[0]).to eq ana_values
      expect(result.values[1]).to eq joao_values
      expect(result.values).not_to include pedro_values
    end

    it 'não insere nenhum médico em caso de erro' do
      repository = DoctorsRepository.new conn: @conn
      ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                       name: 'Ana da Silva', email: 'ana@email.com'
      ana_values = ana.attr_values
      pedro = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                         name: 'Pedro Lopes', email: 'pedro@email.com'
      pedro_values = pedro.attr_values
      joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                        name: 'João Lima', email: 'joao@email.com'
      joao_values = joao.attr_values
      batch = [ana_values, pedro_values, joao_values]

      allow(@conn).to receive(:exec_prepared).and_call_original
      allow(@conn).to receive(:exec_prepared).with('prepared_doctors_insert', joao_values).and_raise(PG::Error)
      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM doctors;'

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end
end
