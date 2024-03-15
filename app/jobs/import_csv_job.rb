require 'sidekiq'
require './app/services/upload_service'

class ImportCsvJob
  include Sidekiq::Job

  def perform(rows)
    UploadService.import rows: rows
  end
end
