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

  def self.new_from_row(row)
    new type: row['tipo exame'], limits: row['limites tipo exame'],
        result: row['resultado tipo exame'], exam_token: row['token resultado exame']
  end
end
