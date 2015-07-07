require_relative '../spec_helper'

describe Rumbrl::Formatter do
  let(:formatter) { Rumbrl::Formatter.new }

  describe '#omit_empty?' do
    it 'defaults to true' do
      expect(formatter.omit_empty?).to be true
    end
  end

  describe '#omit_empty' do
    it 'sets the flag correctly' do
      formatter.omit_empty(false)

      expect(formatter.omit_empty?).to be false
    end

    it 'non-boolean args sets flag to false' do
      formatter.omit_empty(0)
      expect(formatter.omit_empty?).to be false

      formatter.omit_empty('false')
      expect(formatter.omit_empty?).to be false
    end
  end

  describe '#call' do
    context 'when omit_empty? is set' do
      before :each do
        formatter.omit_empty(true)
      end

      it 'it returns empty string' do
        expect(formatter.call('INFO', Time.now, 'SPECS', ''))
      end
    end

    context 'when omit_empty? is not set' do
      before :each do
        formatter.omit_empty(false)
      end

      context ", ENV['LOG_APP_NAME'] is not set" do
        before :each do
          allow(ENV).to receive(:fetch).and_return 'SPECDEFAULT'
        end

        context 'and msg is a string' do
          it 'it returns a formatted string' do
            expected = "[INFO] APP_NAME=SPECDEFAULT::SPECS stuff\n"
            res = formatter.call('INFO', nil, 'SPECS', 'stuff')

            expect(res).to eq expected
          end
        end
      end
    end
  end
end
