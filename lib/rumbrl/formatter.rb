require 'logger'
require 'rumbrl/smash'

module Rumbrl
  # Log4r formatter
  class Formatter < ::Logger::Formatter
    def call(severity, _timestamp, prog, msg)
      return '' if omit_empty? && empty?(msg)

      "[#{severity}] APP_NAME=#{appname(prog)} #{format_msg(msg)}\n"
    end

    def omit_empty(switch)
      if [TrueClass, FalseClass].include? switch.class
        @omit_empty = switch
      else
        @omit_empty = false
      end
    end

    def omit_empty?
      @omit_empty.nil? || @omit_empty
    end

    # overwrite this to format objects that are passed in
    def format_msg(msg)
      "#{msg}"
    end

    private

    def empty?(obj)
      obj.respond_to?(:empty?) && obj.empty?
    end

    def app_namespace
      ENV.fetch('LOG_APP_NAME', 'RubyApplication')
    end

    def appname(progname)
      progname = (progname.nil? || progname.strip.empty?) ? '' : progname.strip
      (progname.empty?) ? app_namespace : "#{app_namespace}::#{progname}"
    end
  end
end
