require 'spec_helper'
require 'active_record'

describe Hearst::ActiveRecordCallbacks do

  class TestModel < ActiveRecord::Base
    include Hearst::ActiveRecordCallbacks
  end

  context 'when included in an active record model' do

    context 'create' do

      it 'publishes an event automatically' do
        expect_any_instance_of(Bunny::Exchange).to receive(:publish)
        model = TestModel.create
      end

      it 'publishes amqp properties if defined' do
        expect_any_instance_of(TestModel).to receive(:amqp_properties)
        model = TestModel.create
      end

    end

    context 'update' do

      it 'published an event automatically' do
        model = TestModel.create(variable: 'foo')
        expect_any_instance_of(Bunny::Exchange).to receive(:publish)
        model.update_attributes(variable: 'bar')
      end

    end
  end

end
