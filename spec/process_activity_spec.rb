require_relative './spec_helper'

RSpec.describe ProcessActivity do
  let(:subject) { ProcessActivity.new(activity_info, logger) }

  let(:activity_info) do
    {
      "action" => 'run_process',
      "path" => path,
      "args" => args,
    }
  end
  let(:path) { 'echo' }
  let(:args) { 'something to say' }
  let(:pid) { 100 }
  let(:logger) { Logger.new('/tmp/test.log')}

  describe "#run" do
    it 'spawns a process with the given arguments' do
        expect(Process).to receive(:spawn).
          with("#{path} #{args}", out: '/dev/null', err: '/dev/null').and_return(pid)

        subject.run
    end
  end
end
