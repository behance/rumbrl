require 'rumbrl/formatter'
require 'rumbrl/smash'

module Rumbrl
  # Rumbrl KV module
  module KV
    # Log4r formatter that turns hashable objects into KV log entries
    class Formatter < ::Rumbrl::Formatter
      def format_msg(msg)
        super unless msg.is_a?(Hash)

        format_data ::Rumbrl::Smash.flatten(msg)
      end

      private

      def format_data(data)
        entry = ''
        data.each do |k, v|
          entry += " #{k.to_s.upcase}='#{v.to_s.gsub("'", '"')}'"
        end
        entry.strip
      end
    end
  end
end
