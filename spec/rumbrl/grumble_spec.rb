require_relative '../spec_helper'

describe Rumbrl::Grumble do
  let(:log) { Rumbrl::Grumble.new 'path/to/log', 'weekly', 123 }

  before(:each) do
    allow_any_instance_of(Logger::LogDevice).to receive(:write)

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
        expect { log.this_is_a_missing_method 'channel', 'sadtimes', {} }
          .to raise_error(NoMethodError)
      end
    end

    context 'method is known' do
      it 'logs correctly' do
        log = Rumbrl::Grumble.new('path/to/log', 'weekly', 123)

        line = /\[.*\] LEVEL='INFO' CHANNEL='channel' MESSAGE='msg' FOO='bar'\n/
        expect_any_instance_of(Logger::LogDevice).to receive(:write).with(line)

        log.info('channel', 'msg', foo: 'bar')
      end
    end
  end
end
