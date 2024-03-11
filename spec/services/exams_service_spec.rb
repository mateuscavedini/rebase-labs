require 'spec_helper'
require './app/services/exams_service'
require './app/repositories/exams_repository'

describe ExamsService do
  context '#batch_insert' do
    it 'deve chamar o repository corretamente' do
      repository_spy = spy ExamsRepository
      allow(ExamsRepository).to receive(:new).and_return(repository_spy)
      service = ExamsService.new conn: @conn
      first_exam = Exam.new token: 'ANY145', date: '2021-12-03', patient_cpf: '000.111.222-34',
                            doctor_crm: 'ANY000CRM', doctor_crm_state: 'SP'
      second_exam = Exam.new token: 'ANY943', date: '2021-01-13', patient_cpf: '999.888.777-65',
                             doctor_crm: 'ANY000CRM', doctor_crm_state: 'SP'
      expected_batch = [first_exam.attr_values, second_exam.attr_values]

      service.batch_insert batch: [first_exam, second_exam], close_conn: false

      expect(repository_spy).to have_received(:batch_insert).with(batch: expected_batch, close_conn: false).once
    end
  end
end
