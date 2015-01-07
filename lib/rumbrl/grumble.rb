require 'rumbrl/log'

module Rumbrl
  # Behance specific logger
  class Grumble < Log
    BASE_DATA_FORMAT = "CHANNEL='%s' MESSAGE='%s'"
    BASE_LOG_FORMAT="[%datetime%] LEVEL='%severity%' %message%"

    def initialize(path, age, size)
      super path, age, size, BASE_DATA_FORMAT, BASE_LOG_FORMAT
      self.datetime_format = "%F %T"
    end

    def method_missing(name, channel, message, **args)
      format = BASE_LOG_FORMAT
      args.each { |k,v| format += " #{k.upcase}='#{v.gsub("'", '"')}'" }
      set_format(format)
      super(*[name, channel, message])
    end
  end
end
