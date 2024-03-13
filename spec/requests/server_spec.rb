require 'spec_helper'
require './app/services/patients_service'
require './app/services/doctors_service'
require './app/services/exams_service'
require './app/services/tests_service'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam'
require './app/models/test'

describe 'Rebase Labs API' do
  context 'GET /hello' do
    it 'deve exibir mensagem inicial' do
      get '/hello'

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'Server rodando!'
    end
  end

  context 'GET /exams' do
    it 'deve retornar todos os exames registrados em ordem desc de data' do
      patients_service = PatientsService.new conn: @conn
      doctors_service = DoctorsService.new conn: @conn
      exams_service = ExamsService.new conn: @conn

      pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                          email: 'pedro@email.com', birthday: '1990-10-25',
                          address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                          state: 'RJ'
      daniela = Patient.new cpf: '763.514.890-75', name: 'Daniela Larissa da Silva',
                            email: 'daniela@email.com', birthday: '2005-04-15',
                            address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                            state: 'SP'
      patients_service.batch_insert batch: [pedro, daniela], close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                               name: 'João Lima', email: 'joao@email.com'
      doctors_service.batch_insert batch: [doctor_ana, doctor_joao], close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: daniela.cpf,
                              doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
      exams_service.batch_insert batch: [pedro_exam, daniela_exam], close_conn: false

      get '/exams'

      json_body = JSON.parse last_response.body

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      expect(json_body.size).to eq 2
      expect(json_body[0]['token']).to eq '0W9I67'
      expect(json_body[0]['patient']['cpf']).to eq '763.514.890-75'
      expect(json_body[0]['doctor']['crm']).to eq 'B0000DHDOF'
      expect(json_body[0]['doctor']['crm_state']).to eq 'MA'
      expect(json_body[1]['token']).to eq 'T9O6AI'
      expect(json_body[1]['patient']['cpf']).to eq '139.363.670-51'
      expect(json_body[1]['doctor']['crm']).to eq 'B000A7CDX4'
      expect(json_body[1]['doctor']['crm_state']).to eq 'SP'
    end
  end

  context 'GET /exams/:token' do
    context 'com sucesso' do
      it 'deve retornar detalhes do exame' do
        patients_service = PatientsService.new conn: @conn
        doctors_service = DoctorsService.new conn: @conn
        exams_service = ExamsService.new conn: @conn
        tests_service = TestsService.new conn: @conn

        pedro = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                            email: 'pedro@email.com', birthday: '1990-10-25',
                            address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                            state: 'RJ'
        daniela = Patient.new cpf: '763.514.890-75', name: 'Daniela Larissa da Silva',
                              email: 'daniela@email.com', birthday: '2005-04-15',
                              address: 'Rua Dalila da Costa, 43', city: 'Sumaré',
                              state: 'SP'
        patients_service.batch_insert batch: [pedro, daniela], close_conn: false

        doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                                name: 'Ana da Silva', email: 'ana@email.com'
        doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                                 name: 'João Lima', email: 'joao@email.com'
        doctors_service.batch_insert batch: [doctor_ana, doctor_joao], close_conn: false

        pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: pedro.cpf,
                              doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
        daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: daniela.cpf,
                                doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
        exams_service.batch_insert batch: [pedro_exam, daniela_exam], close_conn: false

        pedro_test_hdl = Test.new type: 'hdl', limits: '10-50', result: '43', exam_token: pedro_exam.token
        daniela_test_hdl = Test.new type: 'hdl', limits: '10-50', result: '50', exam_token: daniela_exam.token
        daniela_test_ldl = Test.new type: 'ldl', limits: '30-40', result: '23', exam_token: daniela_exam.token
        tests_service.batch_insert batch: [pedro_test_hdl, daniela_test_hdl, daniela_test_ldl], close_conn: false

        get "/exams/#{daniela_exam.token}"

        json_body = JSON.parse last_response.body

        expect(last_response.status).to eq 200
        expect(last_response.content_type).to eq 'application/json'
        expect(json_body['token']).to eq '0W9I67'
        expect(json_body['patient']['name']).to eq 'Daniela Larissa da Silva'
        expect(json_body['doctor']['name']).to eq 'João Lima'
        expect(json_body['tests'][0]['type']).to eq 'hdl'
        expect(json_body['tests'][1]['type']).to eq 'ldl'
      end
    end

    context 'sem sucesso' do
      it 'com token inexistente'
      it 'com erro de servidor'
    end
  end
end
