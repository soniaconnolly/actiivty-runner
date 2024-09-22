require_relative './spec_helper'

RSpec.describe NullActivity do
  let(:subject) { ActivityFactory.new.create(attributes, logger) }
  let(:attributes) do
    {
      "action" => action,
      "path" => '/tmp/new_file'
    }
  end
  let(:action) { 'invalid_action' }

  describe '#run' do
    # send logging output to a string buffer
    let(:logfile) { '/tmp/test_log.json'}
    let(:logger) { JsonLogger.factory(device: logfile, level: Logger::INFO) }
    let(:buffer) { StringIO.new }

    before do
      allow(File).to receive(:open).with(logfile, anything).and_return(buffer)
    end

    it 'logs an error' do
      subject.run

      result = JSON.parse(buffer.string)

      expect(result['action']).to eq(action)
      expect(result['error']).to eq("Invalid action #{action.inspect}")
    end
  end
end
