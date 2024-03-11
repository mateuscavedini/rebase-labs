require 'spec_helper'
require './app/services/tests_service'
require './app/repositories/tests_repository'

describe TestsService do
  context '#batch_insert' do
    it 'deve chamar o repository corretamente' do
      repository_spy = spy TestsRepository
      allow(TestsRepository).to receive(:new).and_return(repository_spy)
      service = TestsService.new conn: @conn
      first_test = Test.new type: 'hemácias', limits: '42-60', result: '53', exam_token: 'ANY954'
      second_test = Test.new type: 'leucócitos', limits: '13-40', result: '32', exam_token: 'ANY547'
      expected_batch = [first_test.attr_values[1..], second_test.attr_values[1..]]

      service.batch_insert batch: [first_test, second_test], close_conn: false

      expect(repository_spy).to have_received(:batch_insert).with(batch: expected_batch, close_conn: false).once
    end
  end
end
