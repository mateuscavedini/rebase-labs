require 'spec_helper'
require './app/modules/model_methods'
require './app/models/patient'
require './app/models/doctor'
require './app/models/exam'

describe ModelMethods do
  context '#attr_values' do
    context 'retorna os valores dos atributos' do
      it 'de um paciente' do
        patient = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                              email: 'pedro@email.com', birthday: '1990-10-25',
                              address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                              state: 'RJ'
        patient.extend ModelMethods

        result = patient.attr_values

        expect(result.size).to eq 7
        expect(result[0]).to eq '139.363.670-51'
        expect(result[1]).to eq 'Pedro Godoi Guedes'
        expect(result[2]).to eq 'pedro@email.com'
        expect(result[3]).to eq '1990-10-25'
        expect(result[4]).to eq 'Rua das Palmeiras, 145'
        expect(result[5]).to eq 'Rio de Janeiro'
        expect(result[6]).to eq 'RJ'
      end

      it 'de um médico' do
        doctor = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                            name: 'Ana da Silva', email: 'ana@email.com'
        doctor.extend ModelMethods

        result = doctor.attr_values

        expect(result.size).to eq 4
        expect(result[0]).to eq 'B000A7CDX4'
        expect(result[1]).to eq 'SP'
        expect(result[2]).to eq 'Ana da Silva'
        expect(result[3]).to eq 'ana@email.com'
      end

      it 'de um exame' do
        patient = Patient.new cpf: '139.363.670-51', name: 'Pedro Godoi Guedes',
                              email: 'pedro@email.com', birthday: '1990-10-25',
                              address: 'Rua das Palmeiras, 145', city: 'Rio de Janeiro',
                              state: 'RJ'
        doctor = Doctor.new crm: 'B000A7CDX4', crm_state: 'SP',
                            name: 'Ana da Silva', email: 'ana@email.com'
        exam = Exam.new token: 'T9O6AI', date: '2021-11-21', patient_cpf: patient.cpf,
                        doctor_crm: doctor.crm, doctor_crm_state: doctor.crm_state
        exam.extend ModelMethods

        result = exam.attr_values

        expect(result.size).to eq 5
        expect(result[0]).to eq 'T9O6AI'
        expect(result[1]).to eq '2021-11-21'
        expect(result[2]).to eq '139.363.670-51'
        expect(result[3]).to eq 'B000A7CDX4'
        expect(result[4]).to eq 'SP'
      end
    end
  end
end
