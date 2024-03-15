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
    new cpf: row[0], name: row[1], email: row[2],
        birthday: row[3], address: row[4],
        city: row[5], state: row[6]
  end
end
