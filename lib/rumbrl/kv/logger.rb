require 'logger'

module Rumbrl
  # Rumbrl KV module
  module KV
    # Log4r logger that uses the KV formatter
    class Logger < ::Logger
      def initialize(*args)
        super
        @formatter = ::Rumbrl::KV::Formatter.new
      end
    end
  end
end
