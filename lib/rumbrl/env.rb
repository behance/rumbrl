module Rumbrl
  # insanely dumb env for an insanely dumb log
  class Env
    def self.log_path
      ENV.fetch('LOG_PATH', ::Dir.getwd)
    end

    def self.shift_size
      ENV.fetch('LOG_SHIFT_SIZE', '1048576').to_i
    end

    def self.shift_age
      ENV.fetch('LOG_SHIFT_AGE', 'weekly')
    end

    def self.time_format
      ENV.fetch('LOG_TIME_FORMAT', '[%F %T %z]')
    end

    def self.log_format
      ENV.fetch('LOG_DATA_FORMAT', '[%s] [%s]')
    end
  end
end
