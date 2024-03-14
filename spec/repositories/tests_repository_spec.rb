require 'spec_helper'
require './app/repositories/tests_repository'
require './app/repositories/patients_repository'
require './app/repositories/doctors_repository'
require './app/repositories/exams_repository'
require './app/models/test'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam'

describe TestsRepository do
  context '#batch_insert' do
    it 'deve inserir testes no banco' do
      tests_repository = TestsRepository.new conn: @conn
      patient = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                            email: 'pedro@email.com', birthday: '1990-10-25',
                            address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                            state: 'RJ'
      PatientsRepository.new(conn: @conn).batch_insert batch: [patient.attr_values], close_conn: false
      doctor = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                          name: 'Ana da Silva', email: 'ana@email.com'
      DoctorsRepository.new(conn: @conn).batch_insert batch: [doctor.attr_values], close_conn: false
      exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient.cpf,
                      doctor_crm: doctor.crm, doctor_crm_state: doctor.crm_state
      ExamsRepository.new(conn: @conn).batch_insert batch: [exam.attr_values], close_conn: false
      red_cells_test = Test.new type: 'hemácias', limits: '45-52',
                                result: '97', exam_token: exam.token
      red_cells_test_values = red_cells_test.attr_values
      hdl_test = Test.new type: 'hdl', limits: '19-75',
                          result: '13', exam_token: exam.token
      hdl_test_values = hdl_test.attr_values
      ldl_test = Test.new type: 'ldl', limits: '45-54',
                          result: '80', exam_token: exam.token
      ldl_test_values = ldl_test.attr_values
      batch = [red_cells_test_values, hdl_test_values, ldl_test_values]

      tests_repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM tests;'

      expect(result.num_tuples).to eq 3
      expect(result.values[0]).to eq red_cells_test_values
      expect(result.values[1]).to eq hdl_test_values
      expect(result.values[2]).to eq ldl_test_values
    end

    it 'não deve inserir nenhum teste no caso de erro' do
      tests_repository = TestsRepository.new conn: @conn
      patient = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                            email: 'pedro@email.com', birthday: '1990-10-25',
                            address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                            state: 'RJ'
      PatientsRepository.new(conn: @conn).batch_insert batch: [patient.attr_values], close_conn: false
      doctor = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                          name: 'Ana da Silva', email: 'ana@email.com'
      DoctorsRepository.new(conn: @conn).batch_insert batch: [doctor.attr_values], close_conn: false
      exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient.cpf,
                      doctor_crm: doctor.crm, doctor_crm_state: doctor.crm_state
      ExamsRepository.new(conn: @conn).batch_insert batch: [exam.attr_values], close_conn: false
      red_cells_test = Test.new type: 'hemácias', limits: '45-52',
                                result: '97', exam_token: exam.token
      red_cells_test_values = red_cells_test.attr_values
      hdl_test = Test.new type: 'hdl', limits: '19-75',
                          result: '13', exam_token: exam.token
      hdl_test_values = hdl_test.attr_values
      ldl_test = Test.new type: 'ldl', limits: '45-54',
                          result: '80', exam_token: exam.token
      ldl_test_values = ldl_test.attr_values
      batch = [red_cells_test_values, hdl_test_values, ldl_test_values]

      allow(@conn).to receive(:exec_prepared).and_call_original
      allow(@conn).to receive(:exec_prepared).with('prepared_tests_insert', ldl_test_values).and_raise(PG::Error)
      tests_repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM tests;'

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end
end
