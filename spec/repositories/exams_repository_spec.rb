require 'spec_helper'
require './app/repositories/exams_repository'
require './app/repositories/patients_repository'
require './app/repositories/doctors_repository'
require './app/repositories/tests_repository'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam'
require './app/models/test'

describe ExamsRepository do
  context '#batch_insert' do
    it 'deve inserir os exames no banco' do
      exams_repository = ExamsRepository.new conn: @conn
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
      patient_bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                                  email: 'bruno@email.com', birthday: '1870-09-18',
                                  address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                                  state: 'PA'
      patients_repository.batch_insert batch: [patient_pedro.attr_values, patient_daniela.attr_values,
                                               patient_bruno.attr_values],
                                       close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_luis = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                               name: 'Luis Lopes', email: 'luis@email.com'
      doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                               name: 'João Lima', email: 'joao@email.com'
      doctors_repository.batch_insert batch: [doctor_ana.attr_values, doctor_luis.attr_values,
                                              doctor_joao.attr_values],
                                      close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient_pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      pedro_exam_values = pedro_exam.attr_values
      daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: patient_daniela.cpf,
                              doctor_crm: doctor_luis.crm, doctor_crm_state: doctor_luis.crm_state
      daniela_exam_values = daniela_exam.attr_values
      bruno_exam = Exam.new token: 'IQCZ17', date: '2021-07-09', patient_cpf: patient_bruno.cpf,
                            doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
      bruno_exam_values = bruno_exam.attr_values
      batch = [pedro_exam_values, daniela_exam_values, bruno_exam_values]

      exams_repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM exams'

      expect(result.num_tuples).to eq 3
      expect(result.values[0]).to eq pedro_exam_values
      expect(result.values[1]).to eq daniela_exam_values
      expect(result.values[2]).to eq bruno_exam_values
    end

    it 'não deve inserir exame com token já registrado' do
      exams_repository = ExamsRepository.new conn: @conn
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
      patient_bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                                  email: 'bruno@email.com', birthday: '1870-09-18',
                                  address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                                  state: 'PA'
      patients_repository.batch_insert batch: [patient_pedro.attr_values, patient_daniela.attr_values,
                                               patient_bruno.attr_values],
                                       close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_luis = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                               name: 'Luis Lopes', email: 'luis@email.com'
      doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                               name: 'João Lima', email: 'joao@email.com'
      doctors_repository.batch_insert batch: [doctor_ana.attr_values, doctor_luis.attr_values,
                                              doctor_joao.attr_values],
                                      close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient_pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      pedro_exam_values = pedro_exam.attr_values
      daniela_exam = Exam.new token: 'T9O6AI', date: '2021-11-21', patient_cpf: patient_daniela.cpf,
                              doctor_crm: doctor_luis.crm, doctor_crm_state: doctor_luis.crm_state
      daniela_exam_values = daniela_exam.attr_values
      bruno_exam = Exam.new token: 'IQCZ17', date: '2021-07-09', patient_cpf: patient_bruno.cpf,
                            doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
      bruno_exam_values = bruno_exam.attr_values
      batch = [pedro_exam_values, daniela_exam_values, bruno_exam_values]

      exams_repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM exams'

      expect(result.num_tuples).to eq 2
      expect(result.values[0]).to eq pedro_exam_values
      expect(result.values[1]).to eq bruno_exam_values
      expect(result.values).not_to include daniela_exam_values
    end

    it 'não insere nenhum exame em caso de erro' do
      exams_repository = ExamsRepository.new conn: @conn
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
      patient_bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                                  email: 'bruno@email.com', birthday: '1870-09-18',
                                  address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                                  state: 'PA'
      patients_repository.batch_insert batch: [patient_pedro.attr_values, patient_daniela.attr_values,
                                               patient_bruno.attr_values],
                                       close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_luis = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                               name: 'Luis Lopes', email: 'luis@email.com'
      doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                               name: 'João Lima', email: 'joao@email.com'
      doctors_repository.batch_insert batch: [doctor_ana.attr_values, doctor_luis.attr_values,
                                              doctor_joao.attr_values],
                                      close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient_pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      pedro_exam_values = pedro_exam.attr_values
      daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: patient_daniela.cpf,
                              doctor_crm: doctor_luis.crm, doctor_crm_state: doctor_luis.crm_state
      daniela_exam_values = daniela_exam.attr_values
      bruno_exam = Exam.new token: 'IQCZ17', date: '2021-07-09', patient_cpf: patient_bruno.cpf,
                            doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
      bruno_exam_values = bruno_exam.attr_values
      batch = [pedro_exam_values, daniela_exam_values, bruno_exam_values]

      allow(@conn).to receive(:exec_prepared).and_call_original
      allow(@conn).to receive(:exec_prepared).with('prepared_exams_insert', bruno_exam_values).and_raise(PG::Error)
      exams_repository.batch_insert batch: batch, close_conn: false
      result = @conn.exec 'SELECT * FROM exams'

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end

  context '#all' do
    it 'deve retornar todos os exames do banco em order desc de data' do
      exams_repository = ExamsRepository.new conn: @conn
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
      patient_bruno = Patient.new cpf: '499.455.830-26', name: 'Bruno Ferreira',
                                  email: 'bruno@email.com', birthday: '1870-09-18',
                                  address: 'Rua Doutor Lucas Dias, 5', city: 'Belém',
                                  state: 'PA'
      patients_repository.batch_insert batch: [patient_pedro.attr_values, patient_daniela.attr_values,
                                               patient_bruno.attr_values],
                                       close_conn: false

      doctor_ana = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                              name: 'Ana da Silva', email: 'ana@email.com'
      doctor_luis = Doctor.new crm: 'B000AR99QO', crm_state: 'SC',
                               name: 'Luis Lopes', email: 'luis@email.com'
      doctor_joao = Doctor.new crm: 'B0000DHDOF', crm_state: 'MA',
                               name: 'João Lima', email: 'joao@email.com'
      doctors_repository.batch_insert batch: [doctor_ana.attr_values, doctor_luis.attr_values,
                                              doctor_joao.attr_values],
                                      close_conn: false

      pedro_exam = Exam.new token: 'T9O6AI', date: '2021-08-05', patient_cpf: patient_pedro.cpf,
                            doctor_crm: doctor_ana.crm, doctor_crm_state: doctor_ana.crm_state
      daniela_exam = Exam.new token: '0W9I67', date: '2021-11-21', patient_cpf: patient_daniela.cpf,
                              doctor_crm: doctor_luis.crm, doctor_crm_state: doctor_luis.crm_state
      bruno_exam = Exam.new token: 'IQCZ17', date: '2021-07-09', patient_cpf: patient_bruno.cpf,
                            doctor_crm: doctor_joao.crm, doctor_crm_state: doctor_joao.crm_state
      exams_repository.batch_insert batch: [pedro_exam.attr_values, daniela_exam.attr_values,
                                            bruno_exam.attr_values],
                                    close_conn: false

      result = exams_repository.all close_conn: false

      expect(result.num_tuples).to eq 3
      expect(result.values[0][0]).to eq '0W9I67'
      expect(result.values[0][2]).to eq '{"name" : "Daniela Larissa da Silva", "cpf" : "763.514.890-75"}'
      expect(result.values[0][3]).to eq '{"name" : "Luis Lopes", "crm" : "B000AR99QO", "crm_state" : "SC"}'
      expect(result.values[1][0]).to eq 'T9O6AI'
      expect(result.values[1][2]).to eq '{"name" : "Pedro Godoi Guedes", "cpf" : "139.363.670-51"}'
      expect(result.values[1][3]).to eq '{"name" : "Ana da Silva", "crm" : "B000A7CDX4", "crm_state" : "SP"}'
      expect(result.values[2][0]).to eq 'IQCZ17'
      expect(result.values[2][2]).to eq '{"name" : "Bruno Ferreira", "cpf" : "499.455.830-26"}'
      expect(result.values[2][3]).to eq '{"name" : "João Lima", "crm" : "B0000DHDOF", "crm_state" : "MA"}'
    end

    it 'retorna vazio caso não haja exames' do
      repository = ExamsRepository.new conn: @conn

      result = repository.all close_conn: false

      expect(result.num_tuples).to eq 0
      expect(result.values).to be_empty
    end
  end

  context '#fetch_by_token' do
    it 'retorna detalhes de um exame' do
      patients_repository = PatientsRepository.new conn: @conn
      doctors_repository = DoctorsRepository.new conn: @conn
      exams_repository = ExamsRepository.new conn: @conn
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
      exams_repository.batch_insert batch: [pedro_exam.attr_values, daniela_exam.attr_values], close_conn: false

      pedro_test_hdl = Test.new type: 'hdl', limits: '10-50', result: '43', exam_token: pedro_exam.token
      pedro_test_ldl = Test.new type: 'ldl', limits: '30-40', result: '23', exam_token: pedro_exam.token
      daniela_test_hdl = Test.new type: 'hdl', limits: '10-50', result: '50', exam_token: daniela_exam.token
      tests_repository.batch_insert batch: [pedro_test_hdl.attr_values, pedro_test_ldl.attr_values,
                                            daniela_test_hdl.attr_values],
                                    close_conn: false

      result = exams_repository.fetch_by_token token: 'T9O6AI', close_conn: false

      expect(result.num_tuples).to eq 1
      expect(result.values[0][0]).to eq 'T9O6AI'
      expect(result.values[0][1]).to eq '2021-08-05'
      expect(result.values[0][2]).to eq '{"name" : "Pedro Godoi Guedes", "cpf" : "139.363.670-51"}'
      expect(result.values[0][3]).to eq '{"name" : "Ana da Silva", "crm" : "B000A7CDX4", "crm_state" : "SP"}'
      expect(result.values[0][4]).to eq '[{"type" : "hdl", "limits" : "10-50", "result" : "43"}, {"type" : "ldl", "limits" : "30-40", "result" : "23"}]'
      expect(result.values[0][4]).not_to include '{"type" : "hdl", "limits" : "10-50", "result" : "50"}'
    end
  end
end
