# frozen-string-literal: true

require 'rake'
require 'csv'
require './app/services/database_service'
require './app/services/tests_service'

namespace :db do
  task :init do
    puts '----> PREPARANDO BANCO DE DADOS...'

    DatabaseService.setup

    puts '----> BANCO DE DADOS PRONTO!'
  end

  task import: [:init] do
    puts '----> IMPORTANDO DADOS...'

    rows = CSV.read './data/data.csv', col_sep: ';', headers: true
    TestsService.new.batch_insert rows.map(&:fields)

    puts '----> IMPORTAÇÃO FINALIZADA!'
  end
end
