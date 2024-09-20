require_relative './spec_helper'

RSpec.describe ActivityRunner do
  let(:subject) { ActivityRunner.new('./activities.json', factory: factory) }

  let(:factory) { ActivityFactory.new }
  context 'logging' do
    it 'logs in json format' do
    end
  end

  context 'activities' do
    it 'reads a json file of activities and creates Activity objects' do
      expect(factory).to receive(:create).and_call_original.exactly(5).times
      subject.run
    end
  end
end
