require 'logger'

module Rumbrl
  # Default logger that uses Rumbrl::Formatter
  class Logger < ::Logger
    def initialize(*args)
      super
      @formatter = Formatter.new
    end
  end
end
