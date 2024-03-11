require './app/modules/model_methods'

class Patient
  include ModelMethods

  attr_reader :cpf
  attr_accessor :name, :email, :birthday, :address, :city, :state

  def initialize(cpf:, name:, email:, birthday:, address:, city:, state:)
    @cpf = cpf
    @name = name
    @email = email
    @birthday = birthday
    @address = address
    @city = city
    @state = state
  end

  def self.new_from_row(row)
    new cpf: row['cpf'], name: row['nome paciente'], email: row['email paciente'],
        birthday: row['data nascimento paciente'], address: row['endereço/rua paciente'],
        city: row['cidade paciente'], state: row['estado paciente']
  end
end
