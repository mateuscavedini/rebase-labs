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
end
