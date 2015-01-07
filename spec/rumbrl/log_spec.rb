require_relative '../spec_helper'

# message is a regex string
def default_log_string(message)
  datetime = Time.now.strftime('%Y-%m-%dT%H:%M:%S.')
  message = 'message \["data"\]'
  /I, \[#{datetime}[0-9]+ ##{Process.pid}\]  INFO -- : #{message}\n/
end

describe Rumbrl::Log do
  let(:log) { Rumbrl::Log.new 'path/to/log', 'weekly', 123, '%s %s' }

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
        expect { log.this_is_a_missing_method 'sadtimes log' }
          .to raise_error(NoMethodError)
      end
    end

    context 'method is known' do
      it 'logs correctly using default log_format' do
        expect_any_instance_of(Logger::LogDevice)
          .to receive(:write).with(default_log_string('message \["data"\]'))

        log.info('message', ['data'])
      end

      it 'logs correctly using custom log_format' do
        log = Rumbrl::Log.new('path/to/log', 'weekly', 123,
                              '%s %s', '%severity% %message%')

        expected_string = "INFO message [\"data\"]\n"

        expect_any_instance_of(Logger::LogDevice)
          .to receive(:write).with(expected_string)

        log.info('message', ['data'])
      end

      it 'logs correctly with custom datetime and custom log_format' do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch)
          .with('LOG_TIME_FORMAT', anything).and_return('[%F]')
        allow(ENV).to receive(:fetch)
          .with('LOG_FORMAT', anything).and_return('%datetime% %message%')

        log = Rumbrl::Factory.create('STDOUT')

        datetime = Time.now.strftime('%Y-%m-%d')
        expected_string = "[#{datetime}] [message] [data]\n"

        expect_any_instance_of(Logger::LogDevice)
          .to receive(:write).with(expected_string)

        log.info('message', 'data')
      end

      it 'truncates extra values based on format string' do
        log = Rumbrl::Log.new('path/to/log', 'weekly', 123,
                              '%s %s %s', '%severity% %message%')

        expect_any_instance_of(Logger::LogDevice)
          .to receive(:write).with("INFO 1 2 3\n")

        log.info(1, 2, 3, 4, 5)
      end
    end
  end
end
