require './app/modules/model_methods'

class Exam
  include ModelMethods

  attr_reader :token, :patient_cpf, :doctor_crm, :doctor_crm_state
  attr_accessor :date

  def initialize(token:, date:, patient_cpf:, doctor_crm:, doctor_crm_state:)
    @token = token
    @date = date
    @patient_cpf = patient_cpf
    @doctor_crm = doctor_crm
    @doctor_crm_state = doctor_crm_state
  end

  def self.new_from_row(row)
    new token: row['token resultado exame'], date: row['data exame'], patient_cpf: row['cpf'],
        doctor_crm: row['crm médico'], doctor_crm_state: row['crm médico estado']
  end
end
