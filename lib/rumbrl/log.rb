require 'forwardable'
require 'logger'

module Rumbrl
  # an insanely dumb file log
  class Log
    extend Forwardable

    ALLOWED_METHODS = [:debug, :info, :warn, :error, :fatal, :unknown]

    attr_reader :logger, :data_format

    def_delegators :logger,
                   :datetime_format,
                   :datetime_format=,
                   :level=,
                   :log,
                   :debug?,
                   :error?,
                   :fatal?,
                   :info?

    def initialize(path, age, size, data_format, log_format = nil)
      @logger = ::Logger.new(log_file(path), shift_age: age, shift_size: size)
      @data_format = data_format
      setup_format(log_format) if log_format
    end

    def method_missing(name, *args)
      name = name.to_sym
      return super(name, *args) unless ALLOWED_METHODS.member? name
      write(args, level: name)
    end

    def setup_format(format)
      @logger.formatter = log_formatter(format)
    end

    private

    def log_file(path)
      file = ::File.open(path, File::WRONLY | File::APPEND | File::CREAT)
      # force buffer flush on write
      file.sync = true
      file
    end

    def write(args, level: :info)
      @logger.method(level).call { format_message args }
    end

    def format_message(values)
      sprintf(*([@data_format] + values))
    end

    def log_formatter(log_format)
      proc do |severity, datetime, progname, message|
        datetime = datetime.strftime(datetime_format) if datetime_format

        values = {
          severity: severity,
          datetime: datetime,
          pid: Process.pid,
          progname: progname,
          message: message
        }

        values.each do |k, v|
          log_format = log_format.gsub(/%#{k.to_s}%/, v.to_s)
        end

        "#{log_format}\n"
      end
    end
  end
end
