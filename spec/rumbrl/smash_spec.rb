require_relative '../spec_helper'

# Mock class for testing
class PopTart
  def to_log
    {
      frosting: 'vanilla',
      filling: 'strawberry'
    }
  end
end

class NotPopTart
end

describe Rumbrl::Smash do
  describe '.flatten' do
    it 'does not change flat hash' do
      source = { bar: 'foo' }
      expect(Rumbrl::Smash.flatten(source)).to eql(source)
    end

    it 'flattens nested hashes with namespaced keys' do
      source = { bar: 'foo', baz: { wee: 'boo' } }
      target = { bar: 'foo', baz_wee: 'boo' }
      expect(Rumbrl::Smash.flatten(source)).to eql(target)
    end

    it 'flattens nested hashes with mixed keys' do
      source = { 'bar' => 'foo', baz: { 'wee' => 'boo' } }
      target = { bar: 'foo', baz_wee: 'boo' }
      expect(Rumbrl::Smash.flatten(source)).to eql(target)
    end

    context 'given an object' do
      context 'that responds to `to_log`' do
        it 'flattens hash representation of the object' do
          source = { bar: 'foo', poptart: PopTart.new }
          target = { bar: 'foo',
                     poptart_frosting: 'vanilla',
                     poptart_filling: 'strawberry' }
          expect(Rumbrl::Smash.flatten(source)).to eql(target)
        end
      end

      context 'that does not responds to `to_log`' do
        it 'does not flatten the object' do
          not_poptart = NotPopTart.new
          source = { bar: 'foo', poptart: not_poptart }
          expect(Rumbrl::Smash.flatten(source)).to eql(source)
        end
      end
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
