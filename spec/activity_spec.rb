require_relative './spec_helper'

RSpec.describe Activity do
  let(:subject) { Activity.new(attributes, logger) }

  let(:attributes) do
    {
      "action" => 'run_process',
      "path" => path,
      "args" => args,
    }
  end
  let(:path) { 'echo' }
  let(:args) { 'something to say' }
  let(:pid) { 100 }

  # send logging output to a string buffer
  let(:logfile) { '/tmp/test_log.json'}
  let(:logger) { JsonLogger.factory(device: logfile, level: Logger::INFO) }
  let(:buffer) { StringIO.new }

  before do
    allow(File).to receive(:open).with(logfile, anything).and_return(buffer)
  end

  describe "#run" do
    it 'spawns a process with the given arguments' do
        expect(Process).to receive(:spawn).
          with("#{path} #{args}", out: '/dev/null', err: '/dev/null').and_return(pid)

        subject.run
    end

    it 'logs the required attributes in json format' do
      subject.run

      result = JSON.parse(buffer.string)

      # Could freeze time here but that would be testing JsonLogger's timestamp functionality
      expect(result['time']).to be_a(String)
      expect(result['level']).to eq('INFO')
      expect(result['action']).to eq('run_process')
      expect(result['process_start_time']).to be_a(String)
      expect(result['process_owner']).to be_a(String)
      expect(result['process_name']).to be_a(String)
      expect(result['command']).to eq("#{path} #{args}")
      expect(result['process_id']).to be_a(Numeric)
    end
  end
end
