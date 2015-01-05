require 'forwardable'
require 'logger'

module Rumbrl
  # an insanely dumb file log
  class Log
    extend Forwardable

    ALLOWED_METHODS = [:debug, :info, :warn, :error, :fatal, :unknown]

    attr_reader :logger, :data_format

    def_delegators :logger,
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

      @logger.formatter = log_formatter(log_format) if log_format
    end

    def log_formatter(log_format)
      # All the underscoring is for rubocop
      proc do |_severity, datetime, _progname, _message|
        # Set some values that can be used in the formatter
        _datetime = datetime.strftime(datetime_format)
        _pid = Process.pid

        formatted_string = log_format.gsub(/%\w+/) do |pattern|
          variable = pattern.gsub('%', '_')

          if binding.local_variable_defined?(variable)
            binding.local_variable_get(variable)
          end
        end

        "#{formatted_string}\n"
      end
    end

    def method_missing(name, *args)
      name = name.to_sym
      return super(name, *args) unless ALLOWED_METHODS.member? name
      fail 'requires a message and data' unless args.size == 2
      write(args[0], data: args[1], level: name)
    end

    private

    def log_file(path)
      # TODO: make this...less hacky
      ::File.open(path, File::WRONLY | File::APPEND | File::CREAT)
    end

    def write(message, level: :info, data: {})
      @logger.method(level).call { format_message message, data }
    end

    def format_message(message, data)
      sprintf @data_format, message, data
    end
  end
end
