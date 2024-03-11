require './app/modules/model_methods'

class Test
  include ModelMethods

  attr_reader :exam_token
  attr_accessor :id, :type, :limits, :result

  def initialize(type:, limits:, result:, exam_token:)
    @id = id
    @type = type
    @limits = limits
    @result = result
    @exam_token = exam_token
  end
end
