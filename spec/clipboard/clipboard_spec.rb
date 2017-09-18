# frozen_string_literal: true

require_relative '../../lib/clipboard/clipboard'

describe Clipboard do
  let(:platform) { 'x86_64-darwin16' }
  before { stub_const('RUBY_PLATFORM', platform) }

  describe '.copy' do
    context 'when on darwin platform' do
      it 'copies string to clipboard' do
        expect(Clipboard).to receive(:system).with "echo 'string' | pbcopy"

        Clipboard.copy 'string'
      end
    end

    context 'when on other platform' do
      let(:platform) { 'win-x86_64' }

      it 'raises NotImplemented' do
        expect { Clipboard.copy('string') }.to raise_error NotImplementedError
      end
    end
  end
end
