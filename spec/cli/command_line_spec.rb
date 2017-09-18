# frozen_string_literal: true

require_relative '../../lib/cli/command_line'

describe Cli::CommandLine do
  let(:interface) { Cli::CommandLine.new }

  context '#send' do
    it 'sends to STDOUT' do
      expect(STDOUT).to receive(:puts).with 'string'

      interface.send 'string'
    end
  end

  context '#receive' do
    it 'receives from STDIN' do
      expect(STDIN).to receive(:gets).and_return 'string'

      expect(interface.receive).to eq 'string'
    end
  end
end
