require_relative '../spec_helper'

describe Rumbrl::Log do
  let(:log) { Rumbrl::Log.new 'path/to/log', 'weekly', 123, '%s %s' }
  let!(:logger_double) { double }

  before(:each) do
    allow(logger_double).to receive(:level=)
    allow(logger_double).to receive(:datetime_format=)
    allow(logger_double).to receive(:formatter=)
    allow(::Logger).to receive(:new).and_return logger_double
    # TODO: make this...less hacky
    allow(::File).to receive(:open).and_return(STDOUT)
  end

  describe 'delegates' do
    it { expect(log).to delegate_method(:log).to(:logger) }
    it { expect(log).to delegate_method(:debug?).to(:logger) }
    it { expect(log).to delegate_method(:error?).to(:logger) }
    it { expect(log).to delegate_method(:fatal?).to(:logger) }
    it { expect(log).to delegate_method(:info?).to(:logger) }
    it do
      expect(log).to delegate_method(:datetime_format=)
        .with_arguments('').to(:logger)
    end
  end

  describe '#method_missing' do
    context 'unknown method is called' do
      it 'fails on unknown method call' do
        expect { log.this_is_a_missing_method 'sadtimes log' }
          .to raise_error(NoMethodError)
      end
    end

    context 'method is known' do
      it 'fails when less than 2 args given' do
        expect { log.debug('boo') }
          .to raise_error(RuntimeError, /message and data/)
      end

      it 'does things woo' do
        expect(logger_double).to receive(:info)
        log.info('message', ['data'])
      end
    end
  end
end
