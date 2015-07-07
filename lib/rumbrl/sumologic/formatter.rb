require 'rumbrl/kv/formatter'

module Rumbrl
  # Rumbrl Sumologic module
  module Sumologic
    # Log4r formatter that turns hashable objects into KV log entries
    # with some decorations specifically for sumologic
    class Formatter < ::Rumbrl::KV::Formatter
      def call(severity, _timestamp, prg, msg)
        return super if empty?(msg)

        "APP_NAME='#{appname(prg)}' SEVERITY='#{severity}' #{format_msg(msg)}\n"
      end

      private

      def app_namespace
        ENV.fetch('LOG_APP_NAME', 'RubyApplication')
      end

      def appname(prog)
        prog = (prog.nil? || prog.strip.empty?) ? '' : prog.strip
        (prog.empty?) ? app_namespace : "#{app_namespace}::#{prog}"
      end
    end
  end
end
