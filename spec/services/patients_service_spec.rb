require 'spec_helper'
require './app/services/patients_service'
require './app/repositories/patients_repository'

describe PatientsService do
  context '#batch_insert' do
    it 'deve chamar o repository corretamente' do
      repository_spy = spy PatientsRepository
      allow(PatientsRepository).to receive(:new).and_return(repository_spy)
      service = PatientsService.new conn: @conn
      first_patient = Patient.new cpf: '000.111.222-34', name: 'Primeiro Paciente',
                                  email: 'primeiro@paciente.com', birthday: '1995-04-10',
                                  address: 'Rua Ficticia, 01', city: 'Santos',
                                  state: 'SP'
      second_patient = Patient.new cpf: '999.888.777-65', name: 'Segundo Paciente',
                                   email: 'segundo@paciente.com', birthday: '1987-10-04',
                                   address: 'Rua Inexistente, 12', city: 'Goiânia',
                                   state: 'GO'
      expected_batch = [first_patient.attr_values, second_patient.attr_values]

      service.batch_insert batch: [first_patient, second_patient], close_conn: false

      expect(repository_spy).to have_received(:batch_insert).with(batch: expected_batch, close_conn: false).once
    end
  end
end
