require_relative '../spec_helper'

describe Rumbrl::GrumbleFactory do
  describe '#generate' do
    it 'creates the log path if it does not exist' do
      path = 'this/should/not/exist'
      expect(::Dir).to receive(:mkdir).with(path)
      allow(::File).to receive(:directory?)
        .with(path)
        .and_return(false)

      log_double = double
      expect(Rumbrl::Grumble).to receive(:new).and_return(log_double)
      expect(log_double).to receive(:level=)
      expect(log_double).to_not receive(:datetime_format=)

      Rumbrl::GrumbleFactory.create 'foo.log', path: path
    end
  end
end
