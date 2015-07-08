require 'rumbrl/kv/formatter'

module Rumbrl
  # Rumbrl Sumologic module
  module Sumologic
    # Log4r formatter that turns hashable objects into KV log entries
    # with some decorations specifically for sumologic
    class Formatter < ::Rumbrl::KV::Formatter
      def call(severity, timestamp, prg, msg)
        return super if empty?(msg)

        format_entry appname(prg), severity, timestamp, format_msg(msg)
      end

      private

      def format_entry(app, sev, time, msg)
        format(
          "APP_NAME='%s' SEVERITY='%s' TIMESTAMP='%s' %s\n",
          app, sev, time, msg
        )
      end

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
