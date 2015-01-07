require 'logger'
require 'rumbrl/env'
require 'rumbrl/log'

module Rumbrl
  # an insanely dumb logger creator
  # broken regulations & underaged workers abound
  class Factory
    attr_reader :dest, :name
    attr_accessor :size, :age, :level, :log_format, :data_format, :time_format

    def self.create(nm, path: nil, age: nil, size: nil, level: nil)
      new(nm, path: path, age: age, size: size, level: level).generate
    end

    def initialize(nm, path: nil, age: nil, size: nil, level: nil)
      @name = nm
      @log_format = Env.log_format
      @data_format = Env.data_format
      @time_format = Env.time_format
      @size ||= (size || Env.shift_size)
      @age ||= (age || Env.shift_age)
      @level ||= (level || ::Logger::INFO)
      @dest = log_dest path, nm
    end

    def generate
      init_path dest
      generate_logger
    end

    def generate_logger
      logger = Log.new(dest, age, size, data_format, log_format)
      logger.level = level
      logger.datetime_format = time_format
      logger
    end

    private

    def log_dest(dir, name)
      return name unless name.is_a? ::String
      dir ||= Env.log_path
      ::File.join dir, name
    end

    def init_path(path)
      dir = ::File.dirname path
      ::Dir.mkdir(dir) unless ::File.directory? dir
    end
  end
end
