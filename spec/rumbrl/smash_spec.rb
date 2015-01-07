require_relative '../spec_helper'

describe Rumbrl::Smash do
  describe '.flatten' do
    it 'does not change flat hash' do
      target = { bar: 'foo' }
      expect(Rumbrl::Smash.flatten(target)).to eql target
    end

    it 'flattens nested hashes with namespaced keys' do
      target = { bar: 'foo', baz: { wee: 'boo' } }
      flattened = { bar: 'foo', baz_wee: 'boo' }
      expect(Rumbrl::Smash.flatten(target)).to eql flattened
    end
  end

  describe '.build_namespace' do
    it 'works' do
      expect(Rumbrl::Smash.build_namespace('foo', 'bar')).to eql 'foo_bar'
    end

    it 'does not prepend when previous namespace is empty' do
      expect(Rumbrl::Smash.build_namespace('', 'bar')).to eql 'bar'
    end
  end
end
