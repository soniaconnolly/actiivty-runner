require_relative './spec_helper'

RSpec.describe ModifyFileActivity do
  let(:subject) { ModifyFileActivity.new(attributes, logger) }

  let(:attributes) do
    {
      "action" => 'modify_file',
      "path" => path,
      "data" => data,
    }
  end
  let(:path) { '/tmp/test_file' }
  let(:data) { 'Append this to the file.' }
  let(:pid) { 100 }
  let(:command) { "echo '#{data}' >> #{path}" }

  # send logging output to a string buffer
  let(:logfile) { '/tmp/test_log.json'}
  let(:logger) { JsonLogger.factory(device: logfile, level: Logger::INFO) }
  let(:buffer) { StringIO.new }

  before do
    allow(File).to receive(:open).with(logfile, 9).and_return(buffer)
  end

  describe "#run" do
    it 'spawns a process with the given arguments' do
        expect(Process).to receive(:spawn).
          with(command, out: '/dev/null', err: '/dev/null').and_return(pid)

        subject.run
    end

    it 'logs the required attributes in json format' do
      subject.run

      result = JSON.parse(buffer.string)

      # Could freeze time here but that would be testing JsonLogger's timestamp functionality
      expect(result['time']).to be_a(String)
      expect(result['process_start_time']).to be_a(String)
      expect(result['path']).to eq(path)
      expect(result['action']).to eq('modify_file')
      expect(result['process_owner']).to be_a(String)
      expect(result['process_name']).to be_a(String)
      expect(result['command']).to eq(command)
      expect(result['process_id']).to be_a(Numeric)
    end
  end
end
