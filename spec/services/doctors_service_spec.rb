require 'spec_helper'
require './app/services/doctors_service'
require './app/repositories/doctors_repository'

describe DoctorsService do
  context '#batch_insert' do
    it 'deve chamar o repository corretamente' do
      repository_spy = spy DoctorsRepository
      allow(DoctorsRepository).to receive(:new).and_return(repository_spy)
      service = DoctorsService.new conn: @conn
      first_doctor = Doctor.new name: 'Primeiro Médico', email: 'primeiro@medico.com',
                                crm: 'ANY000CRM', crm_state: 'SP'
      second_doctor = Doctor.new name: 'Segundo Médico', email: 'segundo@medico.com',
                                 crm: 'ANY999CRM', crm_state: 'SP'
      expected_batch = [first_doctor.attr_values, second_doctor.attr_values]

      service.batch_insert batch: [first_doctor, second_doctor], close_conn: false

      expect(repository_spy).to have_received(:batch_insert).with(batch: expected_batch, close_conn: false).once
    end
  end
end
