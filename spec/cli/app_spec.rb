# frozen_string_literal: true

require_relative '../../lib/cli/app'

describe Cli::App do
  let(:interface) { double }
  let(:collector) { double }
  let(:app) { Cli::App.new interface, collector }

  describe '#run' do
    context 'when token successfully created' do
      it 'displays success message' do
        expect(collector).to receive(:collect).and_return somekey: 'somevalue'
        expect(JWT).to receive(:encode).with({ somekey: 'somevalue' }, 'my$ecretK3y', 'HS256').and_return 'encoded'
        expect(Clipboard).to receive(:copy).with('encoded').and_return true
        expect(interface).to receive(:send).with 'The JWT has been copied to your clipboard!'

        app.run
      end
    end

    context 'when token was not created' do
      it 'displays error message' do
        expect(collector).to receive(:collect).and_return somekey: 'somevalue'
        expect(JWT).to receive(:encode).with({ somekey: 'somevalue' }, 'my$ecretK3y', 'HS256').and_raise JWT::InvalidPayload
        expect(interface).to receive(:send).with 'There was a problem creating token'

        app.run
      end
    end

    context 'when copy to clipboard failed' do
      it 'displays error message' do
        expect(collector).to receive(:collect).and_return somekey: 'somevalue'
        expect(JWT).to receive(:encode).with({ somekey: 'somevalue' }, 'my$ecretK3y', 'HS256').and_return 'encoded'
        expect(Clipboard).to receive(:copy).with('encoded').and_raise NotImplementedError
        expect(interface).to receive(:send).with 'Cannot copy token due to unsupported platform'

        app.run
      end
    end
  end
end
