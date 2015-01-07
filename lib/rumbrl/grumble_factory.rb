require 'rumbrl/log'
require 'rumbrl/grumble'

module Rumbrl
  # dumb factory that grumbles
  class GrumbleFactory < Factory
    def generate_logger
      logger = Grumble.new(dest, age, size)
      logger.level = level
      logger
    end
  end
end
