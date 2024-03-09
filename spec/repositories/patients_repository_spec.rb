require 'spec_helper'
require './app/repositories/patients_repository'
require './app/models/patient'

describe PatientsRepository do
  context '#batch_insert' do
    it 'deve inserir pacientes no banco' do
      repository = PatientsRepository.new conn: @conn
      pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                          email: 'pedro@email.com', birthday: '1990-10-25',
                          address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                          state: 'RJ'
      pedro_values = pedro.attr_values
      daniela = Patient.new cpf: '763.514.890-75', name: 'Daniela Larissa da Silva',
                            email: 'daniela@email.com', birthday: '2005-04-15',
                            address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                            state: 'SP'
      daniela_values = daniela.attr_values
      bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                          email: 'bruno@email.com', birthday: '1870-09-18',
                          address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                          state: 'PA'
      bruno_values = bruno.attr_values
      batch = [pedro_values, daniela_values, bruno_values]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM patients;'

      expect(result.num_tuples).to eq 3
      expect(result.values[0]).to eq pedro_values
      expect(result.values[1]).to eq daniela_values
      expect(result.values[2]).to eq bruno_values
    end

    it 'não insere paciente com cpf já registrado' do
      repository = PatientsRepository.new conn: @conn
      pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                          email: 'pedro@email.com', birthday: '1990-10-25',
                          address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                          state: 'RJ'
      pedro_values = pedro.attr_values
      daniela = Patient.new cpf: '139.363.670-51', name: 'Daniela Larissa da Silva',
                            email: 'daniela@email.com', birthday: '2005-04-15',
                            address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                            state: 'SP'
      daniela_values = daniela.attr_values
      bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                          email: 'bruno@email.com', birthday: '1870-09-18',
                          address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                          state: 'PA'
      bruno_values = bruno.attr_values
      batch = [pedro_values, daniela_values, bruno_values]

      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM patients;'

      expect(result.num_tuples).to eq 2
      expect(result.values[0]).to eq pedro_values
      expect(result.values[1]).to eq bruno_values
      expect(result.values).not_to include daniela_values
    end

    it 'não insere nenhum dado em caso de erro' do
      repository = PatientsRepository.new conn: @conn
      pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                          email: 'pedro@email.com', birthday: '1990-10-25',
                          address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                          state: 'RJ'
      pedro_values = pedro.attr_values
      daniela = Patient.new cpf: '763.514.890-75', name: 'Daniela Larissa da Silva',
                            email: 'daniela@email.com', birthday: '2005-04-15',
                            address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                            state: 'SP'
      daniela_values = daniela.attr_values
      bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                          email: 'bruno@email.com', birthday: '1870-09-18',
                          address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                          state: 'PA'
      bruno_values = bruno.attr_values
      batch = [pedro_values, daniela_values, bruno_values]

      allow(@conn).to receive(:exec_prepared).and_call_original
      allow(@conn).to receive(:exec_prepared).with('prepared_insert', bruno_values).and_raise(PG::Error)
      repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM patients;'

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end
end
