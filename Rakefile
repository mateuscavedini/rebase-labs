# frozen-string-literal: true

require 'rake'
require 'csv'
require './app/services/database_service'
require './app/services/upload_service'

namespace :db do
  task :init do
    puts '----> PREPARANDO BANCO DE DADOS...'

    DatabaseService.setup

    puts '----> BANCO DE DADOS PRONTO!'
  end

  task import: [:init] do
    puts '----> IMPORTANDO DADOS...'

    rows = CSV.read 'data/data.csv', col_sep: ';'
    UploadService.import rows: rows

    puts '----> IMPORTAÇÃO FINALIZADA!'
  end
end
