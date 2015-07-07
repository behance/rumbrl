require 'logger'

module Rumbrl
  # Rumbrl Sumologic module
  module Sumologic
    # Log4r logger that uses the KV formatter
    class Logger < ::Logger
      def initialize(*args)
        super
        @formatter = ::Rumbrl::Sumologic::Formatter.new
      end
    end
  end
end
