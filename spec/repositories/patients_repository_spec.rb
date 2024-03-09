require 'spec_helper'
require './app/repositories/patients_repository'

describe PatientsRepository do
  context '#batch_insert' do
    it 'deve inserir pacientes no banco' do
      repository = PatientsRepository.new conn: @conn
      pedro = ['139.363.670-51', 'Pedro Godoi Guedes', 'pedro@email.com',
               '1990-10-25', 'Rua das Palmeiras, 145', 'Rio de Janeiro', 'RJ']
      daniela = ['763.514.890-75', 'Daniela Larissa da Silva', 'daniela@email.com',
                 '2005-04-15', 'Rua Dalila da Costa, 43', 'Sumaré', 'SP']
      bruno = ['499.455.830-26', 'Bruno Ferreira', 'bruno@email.com',
               '1870-09-18', 'Rua Doutor Lucas Dias, 5', 'Belém', 'PA']
      batch = [pedro, daniela, bruno]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM patients;'

      expect(result.num_tuples).to eq 3
      expect(result.values[0]).to eq pedro
      expect(result.values[1]).to eq daniela
      expect(result.values[2]).to eq bruno
    end

    it 'não insere paciente com cpf já registrado' do
      repository = PatientsRepository.new conn: @conn
      pedro = ['139.363.670-51', 'Pedro Godoi Guedes', 'pedro@email.com',
               '1990-10-25', 'Rua das Palmeiras, 145', 'Rio de Janeiro', 'RJ']
      daniela = ['139.363.670-51', 'Daniela Larissa da Silva', 'daniela@email.com',
                 '2005-04-15', 'Rua Dalila da Costa, 43', 'Sumaré', 'SP']
      batch = [pedro, daniela]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM patients;'

      expect(result.num_tuples).to eq 1
      expect(result.values[0]).to eq pedro
      expect(result.values).not_to include daniela
    end

    it 'não insere nenhum dado em caso de erro' do
      repository = PatientsRepository.new conn: @conn
      pedro = ['139.363.670-51', 'Pedro Godoi Guedes', 'pedro@email.com',
               '1990-10-25', 'Rua das Palmeiras, 145', 'Rio de Janeiro', 'RJ']
      daniela = ['763.514.890-75', 'Daniela Larissa da Silva', 'daniela@email.com',
                 '2005-04-15', 'Rua Dalila da Costa, 43', 'Sumaré', 'SP']
      bruno = ['499.455.830-26', 'Bruno Ferreira', 'bruno@email.com',
               '1870-09-18', 'Rua Doutor Lucas Dias, 5', 'Belém', 'PA']
      batch = [pedro, daniela, bruno]

      allow(@conn).to receive(:exec_prepared).and_call_original
      allow(@conn).to receive(:exec_prepared).with('prepared_insert', bruno).and_raise(PG::Error)
      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM patients;'

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end
end
