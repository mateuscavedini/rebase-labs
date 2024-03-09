require './app/modules/model_methods'

class Doctor
  include ModelMethods

  attr_reader :crm, :crm_state
  attr_accessor :name, :email

  def initialize(crm:, crm_state:, name:, email:)
    @crm = crm
    @crm_state = crm_state
    @name = name
    @email = email
  end
end
