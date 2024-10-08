require_relative './spec_helper'

RSpec.describe ActivityFactory do
  let(:subject) { ActivityFactory.new }

  let(:activity_info) do
    {
      'action' => action,
      'path' => path,
      'type' => 'text'
    }
  end
  let(:logger) { Logger.new('/tmp/test.log')}
  let(:path) { '/tmp/new_file' }

  describe '#create' do
    context 'action is run_process' do
      let(:action) { 'run_process'}
      it 'creates an Activity object' do
        expect(subject.create(activity_info, logger).class).to eq(Activity)
      end
    end

    context 'action is create_file' do
      let(:action) { 'create_file'}
      it 'creates a CreateFileActivity object' do
        expect(subject.create(activity_info, logger).class).to eq(CreateFileActivity)
      end
    end

    context 'action is modify_file' do
      let(:action) { 'modify_file'}
      it 'creates a ModifyFileActivity object' do
        expect(subject.create(activity_info, logger).class).to eq(ModifyFileActivity)
      end
    end

    context 'action is delete_file' do
      let(:action) { 'delete_file'}
      it 'creates a DeleteFileActivity object' do
        expect(subject.create(activity_info, logger).class).to eq(DeleteFileActivity)
      end
    end

    context 'action is network_request' do
      let(:action) { 'network_request'}
      it 'creates a NetworkActivity object' do
        expect(subject.create(activity_info, logger).class).to eq(NetworkActivity)
      end
    end

    context 'action is invalid' do
      let(:action) { 'no_such_action'}
      it 'creates a NullActivity object' do
        expect(subject.create(activity_info, logger).class).to eq(NullActivity)
      end
    end

    context 'path is missing' do
      let(:action) { 'delete_file' }
      let(:path) { nil }

      it 'creates a NullActivity object' do
        expect(subject.create(activity_info, logger).class).to eq(NullActivity)
      end
    end
  end
end
