require 'spec_helper'
require './app/services/tests_service'
require './app/repositories/tests_repository'

describe TestsService do
  context '#batch_insert' do
    it 'deve chamar o repository corretamente' do
      repository_spy = spy TestsRepository
      allow(TestsRepository).to receive(:new).and_return(repository_spy)
      service = TestsService.new conn: @conn
      batch = [%w[data_1 data_2], %w[data_3 data_4]]

      service.batch_insert batch: batch, close_conn: false

      expect(repository_spy).to have_received(:batch_insert).with(batch: batch, close_conn: false).once
    end
  end
end
