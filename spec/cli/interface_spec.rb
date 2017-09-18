# frozen_string_literal: true

require_relative '../../lib/cli/interface'

describe Cli::Interface do
  let(:interface) { Cli::Interface.new }

  context '#send' do
    it 'raises NotImplementedError' do
      expect { interface.send('string') }.to raise_error NotImplementedError
    end
  end

  context '#receive' do
    it 'raises NotImplementedError' do
      expect { interface.receive }.to raise_error NotImplementedError
    end
  end
end
