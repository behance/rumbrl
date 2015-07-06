require 'logger'
require 'rumbrl/smash'

module Rumbrl
  # Log4r formatter
  class Formatter < ::Logger::Formatter
    def call(severity, timestamp, prog, msg)
      return '' if msg.empty? && omit_empty?

      "[#{timestamp}] #{severity} - #{appname(prog)} #{format_msg(msg)}\n"
    end

    def omit_empty(switch)
      if [TrueClass, FalseClass].include? switch.class
        @omit_empty = switch
      else
        @omit_empty = false
      end
    end

    def omit_empty?
      # default to true
      @omit_empty.nil? || @omit_empty
    end

    private

    def format_msg(thing)
      (thing.class == String) ? thing : Smash.flatten(thing)
    end

    def app_namespace
      cfg = ENV.fetch('LOG_APP_NAME', '')
      cfg = "#{cfg}::" unless cfg.empty?
      cfg
    end

    def appname(progname)
      progname = (progname.strip.empty?) ? 'RubyApplication' : progname.strip

      "APP_NAME=#{app_namespace}#{progname}"
    end
  end
end
