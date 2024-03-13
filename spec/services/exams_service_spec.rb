require 'spec_helper'
require './app/services/exams_service'
require './app/repositories/exams_repository'
require './app/repositories/patients_repository'
require './app/repositories/doctors_repository'
require './app/repositories/tests_repository'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam'
require './app/models/test'

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

  context '#fetch_all' do
    it 'retorna json com exames em order desc de data' do
      exams_service = ExamsService.new conn: @conn
      patients_repository = PatientsRepository.new conn: @conn
      doctors_repository = DoctorsRepository.new conn: @conn

      patient_pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                                  email: 'pedro@email.com', birthday: '1990-10-25',
                                  address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                                  state: 'RJ'
      patient_daniela = Patient.new cpf: '763.514.890-75', name: 'Daniela Larissa da Silva',
                                    email: 'daniela@email.com', birthday: '2005-04-15',
                                    address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                                    state: 'SP'
      patients_repository.batch_insert batch: [patient_pedro.attr_values, patient_daniela.attr_values],
                                       close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_luis = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                               name: 'Luis Lopes', email: 'luis@email.com'
      doctors_repository.batch_insert batch: [doctor_ana.attr_values, doctor_luis.attr_values],
                                      close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient_pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: patient_daniela.cpf,
                              doctor_crm: doctor_luis.crm, doctor_crm_state: doctor_luis.crm_state
      exams_service.batch_insert batch: [pedro_exam, daniela_exam],
                                 close_conn: false

      result = exams_service.fetch_all close_conn: false
      result_json = JSON.parse result

      expect(result_json[0]['token']).to eq '0W9I67'
      expect(result_json[0]['patient']['name']).to eq 'Daniela Larissa da Silva'
      expect(result_json[0]['doctor']['name']).to eq 'Luis Lopes'
      expect(result_json[1]['token']).to eq 'T9O6AI'
      expect(result_json[1]['patient']['name']).to eq 'Pedro Godoi Guedes'
      expect(result_json[1]['doctor']['name']).to eq 'Ana da Silva'
    end
  end

  context '#fetch_by_token' do
    it 'retorna json com detalhes de exame' do
      exams_service = ExamsService.new conn: @conn
      patients_repository = PatientsRepository.new conn: @conn
      doctors_repository = DoctorsRepository.new conn: @conn
      tests_repository = TestsRepository.new conn: @conn

      pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                          email: 'pedro@email.com', birthday: '1990-10-25',
                          address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                          state: 'RJ'
      daniela = Patient.new cpf: '763.514.890-75', name: 'Daniela Larissa da Silva',
                            email: 'daniela@email.com', birthday: '2005-04-15',
                            address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                            state: 'SP'
      patients_repository.batch_insert batch: [pedro.attr_values, daniela.attr_values], close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                               name: 'João Lima', email: 'joao@email.com'
      doctors_repository.batch_insert batch: [doctor_ana.attr_values, doctor_joao.attr_values], close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: daniela.cpf,
                              doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
      exams_service.batch_insert batch: [pedro_exam, daniela_exam], close_conn: false

      pedro_test_hdl = Test.new type: 'hdl', limits: '10-50', result: '43', exam_token: pedro_exam.token
      pedro_test_ldl = Test.new type: 'ldl', limits: '30-40', result: '23', exam_token: pedro_exam.token
      daniela_test_hdl = Test.new type: 'hdl', limits: '10-50', result: '50', exam_token: daniela_exam.token
      tests_repository.batch_insert batch: [pedro_test_hdl.attr_values[1..], pedro_test_ldl.attr_values[1..],
                                            daniela_test_hdl.attr_values[1..]],
                                    close_conn: false

      result = exams_service.fetch_by_token token: 'T9O6AI', close_conn: false
      result_json = JSON.parse result

      expect(result_json['token']).to eq 'T9O6AI'
      expect(result_json['date']).to eq '2021-08-05'
      expect(result_json['patient']['name']).to eq 'Pedro Godoi Guedes'
      expect(result_json['doctor']['name']).to eq 'Ana da Silva'
      expect(result_json['tests'].size).to eq 2
      expect(result_json['tests'][0]['type']).to eq 'hdl'
      expect(result_json['tests'][1]['type']).to eq 'ldl'
    end
  end
end
