require './app/repositories/tests_repository'

class TestsService
  def initialize(repository: TestsRepository)
    @repository = repository.new
  end

  def fetch_all
    @repository.all.to_a.to_json
  end
end
