require 'uri'

require_relative './spec_helper'

RSpec.describe NetworkActivity do
  let(:subject) { NetworkActivity.new(attributes, logger) }

  let(:attributes) do
    {
      "action" => 'network_request',
      "path" => path,
      "protocol" => protocol,
      "data" => data,
    }
  end
  # Test urls from
  # https://www.postman.com/cs-demo/postman-customer-org-s-public-workspace/documentation/q34m218/postman-echo
  let(:path) { 'https://postman-echo.com/get' }
  let(:protocol) { 'GET' }
  let(:data) { 'Send this data to the server.' }
  let(:pid) { 100 }
  let(:command) { "curl https://postman-echo.com/get?Send%20this%20data%20to%20the%20server." }

  # send logging output to a string buffer
  let(:logfile) { '/tmp/test_log.json'}
  let(:logger) { JsonLogger.factory(device: logfile, level: Logger::INFO) }
  let(:buffer) { StringIO.new }

  before do
    allow(File).to receive(:open).with(logfile, anything).and_return(buffer)
  end

  describe "#run" do
    context 'GET (default protocol)' do
      it 'spawns a process with the given arguments' do
        expect(Process).to receive(:spawn).
          with(command, out: '/dev/null', err: '/dev/null').and_return(pid)

        subject.run
      end
    end

    context 'POST' do
      let(:protocol) { 'POST' }
      let(:path) { 'https://postman-echo.com:8080/post' }
      let(:command) { "curl --data-urlencode '#{data}' https://postman-echo.com:8080/post" }

      it 'spawns a process with the given arguments' do
        expect(Process).to receive(:spawn).
          with(command, out: '/dev/null', err: '/dev/null').and_return(pid)

        subject.run
      end
    end

    it 'logs the required attributes in json format' do
      subject.run

      result = JSON.parse(buffer.string)

      # Could freeze time here but that would be testing JsonLogger's timestamp functionality
      expect(result['time']).to be_a(String)
      expect(result['process_start_time']).to be_a(String)
      expect(result['path']).to eq(path)
      expect(result['action']).to eq('network_request')
      expect(result['port']).to eq(443)
      expect(result['protocol']).to eq(protocol)
      expect(result['process_owner']).to be_a(String)
      expect(result['process_name']).to be_a(String)
      expect(result['command']).to eq(command)
      expect(result['process_id']).to be_a(Numeric)
    end
  end
end
