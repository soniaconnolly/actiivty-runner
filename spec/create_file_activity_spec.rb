require_relative './spec_helper'

RSpec.describe CreateFileActivity do
  let(:subject) { CreateFileActivity.new(attributes, logger) }

  let(:attributes) do
    {
      "action" => 'create_file',
      "path" => path,
    }
  end
  let(:path) { '/tmp/test_file' }
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
          with("touch #{path}", out: '/dev/null', err: '/dev/null').and_return(pid)

        subject.run
    end

    it 'logs the required attributes in json format' do
      subject.run

      result = JSON.parse(buffer.string)

      # Could freeze time here but that would be testing JsonLogger's timestamp functionality
      expect(result['time']).to be_a(String)
      expect(result['process_start_time']).to be_a(String)
      expect(result['path']).to eq(path)
      expect(result['action']).to eq('create_file')
      expect(result['process_owner']).to be_a(String)
      expect(result['process_name']).to be_a(String)
      expect(result['command']).to eq("touch #{path}")
      expect(result['process_id']).to be_a(Numeric)
    end
  end
end
