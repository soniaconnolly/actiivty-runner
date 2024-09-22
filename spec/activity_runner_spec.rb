require_relative './spec_helper'

RSpec.describe ActivityRunner do
  let(:subject) { ActivityRunner.new('./spec/fixtures/test_activities.json', factory: factory) }

  let(:factory) { ActivityFactory.new }

  context 'activities' do
    it 'reads a json file of activities and creates Activity objects' do
      expect(factory).to receive(:create).and_call_original.exactly(6).times
      subject.run
    end

    it 'runs the Activity objects' do
      receive_count = 0
      allow_any_instance_of(Activity).to receive(:run) { receive_count += 1 }

      subject.run

      expect(receive_count).to eq(6)
    end
  end
end
