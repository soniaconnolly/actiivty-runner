require_relative './spec_helper'

RSpec.describe ActivityRunner do
  let(:subject) { ActivityRunner.new('./spec/fixtures/test_activities.json', factory: factory) }

  let(:factory) { ActivityFactory.new }

  context 'activities' do
    it 'reads a json file of activities and creates Activity objects' do
      expect(factory).to receive(:create).and_call_original.exactly(6).times
      VCR.use_cassette('activity_runner') do
        subject.run
      end
    end
  end
end
