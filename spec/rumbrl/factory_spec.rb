require_relative '../spec_helper'

describe Rumbrl::Factory do
  describe '.create' do
    it 'is just a dumb wrapper for .new and #generate' do
      instance = double
      expect(Rumbrl::Factory).to receive(:new)
        .with('foo', path: nil, age: nil, size: nil, level: nil)
        .and_return(instance)
      expect(instance).to receive(:generate)

      Rumbrl::Factory.create 'foo'
    end
  end

  describe '#initialize' do
    it 'sets proper default values' do
      expect(Rumbrl::Env).to receive(:log_format).and_return(nil)
      expect(Rumbrl::Env).to receive(:time_format).and_return(nil)
      expect(Rumbrl::Env).to receive(:shift_size).and_return(nil)
      expect(Rumbrl::Env).to receive(:shift_age).and_return(nil)

      factory = Rumbrl::Factory.new 'foo'

      expect(factory.name).to eql 'foo'
      expect(factory.log_format).to eql nil
      expect(factory.time_format).to eql nil
      expect(factory.size).to eql nil
      expect(factory.age).to eql nil
      expect(factory.level).to eql ::Logger::INFO
      expect(factory.dest).to eql ::File.join(::Dir.getwd, 'foo')
    end

    it 'respects user-defined log overrides' do
      expect(Rumbrl::Env).to_not receive(:shift_size)
      expect(Rumbrl::Env).to_not receive(:shift_age)

      factory = Rumbrl::Factory.new 'foo',
                                    path: 'some/path',
                                    age: 5,
                                    size: 2,
                                    level: ::Logger::DEBUG
      factory.time_format = 'WOO'
      factory.log_format = 'BLAH'

      expect(factory.name).to eql 'foo'
      expect(factory.log_format).to eql 'BLAH'
      expect(factory.time_format).to eql 'WOO'
      expect(factory.size).to eql 2
      expect(factory.age).to eql 5
      expect(factory.level).to eql ::Logger::DEBUG
      expect(factory.dest).to eql ::File.join('some/path', 'foo')
    end

    it 'respects non-file log paths' do
      factory = Rumbrl::Factory.new STDOUT, path: 'wont/work'

      expect(factory.dest).to eql STDOUT
    end
  end

  describe '#generate' do
    it 'creates the log path if it does not exist' do
      path = 'this/should/not/exist'
      expect(::Dir).to receive(:mkdir).with(path)
      allow(::File).to receive(:directory?)
        .with(path)
        .and_return(false)

      log_double = double
      expect(Rumbrl::Log).to receive(:new).and_return(log_double)
      expect(log_double).to receive(:level=)
      expect(log_double).to receive(:datetime_format=)

      Rumbrl::Factory.create 'foo.log', path: path
    end
  end
end
