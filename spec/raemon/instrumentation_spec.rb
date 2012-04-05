require 'spec_helper'

describe Raemon::Instrumentation do
  # Have to extend due to the way anonymous classes work
  subject { Class.new { extend Raemon::Instrumentation } }

  describe '#instrument' do
    context 'instrumentor available' do
      let(:instrumentor) { double('Instrumentor') }

      before do
        instrumentor.stub(:instrument) do |name, payload={}|
          yield payload if block_given?
          name
        end

        Raemon.config.instrumentor = instrumentor
      end

      after do
        Raemon.config.instrumentor = nil
      end

      it 'uses it appropriately' do
        instrumentor.should_receive(:instrument).with('raemon.bacon', { hello: 'world' })
        subject.instrument('bacon', { hello: 'world' })
      end

      it 'yields the payload correctly' do
        subject.instrument('bacon', 'my payload') do |payload|
          payload.should eq('my payload')
        end
      end
    end

    context 'instrumentor not available' do
      it 'does nothing' do
        expect {
          subject.instrument 'bacon'
        }.to_not raise_error
      end
    end
  end
end
