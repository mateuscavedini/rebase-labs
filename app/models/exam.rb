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
end
