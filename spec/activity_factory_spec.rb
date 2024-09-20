require_relative './spec_helper'

RSpec.describe ActivityFactory do
  let(:subject) { ActivityFactory.new }

  let(:activity_info) do
    {
      'action' => action,
      'path' => '/tmp/new_file',
      'type' => 'text'
    }
  end

  describe '#create' do
    context 'action is run_process' do
      let(:action) { 'run_process'}
      it 'creates a ProcessActivity object' do
        expect(subject.create(activity_info).class).to eq(ProcessActivity)
      end
    end

    context 'action is create_file' do
      let(:action) { 'create_file'}
      it 'creates a FileActivity object' do
        expect(subject.create(activity_info).class).to eq(FileActivity)
      end
    end

    context 'action is modify_file' do
      let(:action) { 'modify_file'}
      it 'creates a FileActivity object' do
        expect(subject.create(activity_info).class).to eq(FileActivity)
      end
    end

    context 'action is delete_file' do
      let(:action) { 'delete_file'}
      it 'creates a FileActivity object' do
        expect(subject.create(activity_info).class).to eq(FileActivity)
      end
    end

    context 'action is network_request' do
      let(:action) { 'network_request'}
      it 'creates a NetworkActivity object' do
        expect(subject.create(activity_info).class).to eq(NetworkActivity)
      end
    end

    context 'action is invalid' do
      let(:action) { 'no_such_action'}
      it 'creates a NullActivity object' do
        expect(subject.create(activity_info).class).to eq(NullActivity)
      end
    end
  end
end
