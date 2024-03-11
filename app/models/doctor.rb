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

  def self.new_from_row(row)
    new name: row['nome médico'], email: row['email médico'],
        crm: row['crm médico'], crm_state: row['crm médico estado']
  end
end
