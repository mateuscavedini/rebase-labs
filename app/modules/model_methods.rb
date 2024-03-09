module ModelMethods
  def attr_values
    instance_variables.map { |attr| instance_variable_get attr }
  end
end
