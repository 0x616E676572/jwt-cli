# frozen_string_literal: true

require_relative '../../lib/cli/collector'

describe Cli::Collector do
  let(:interface) { double }
  let(:required_keys) { %i[email user_id] }
  let(:validators) { { email: EmailValidator } }
  let(:collector) { Cli::Collector.new interface, required_keys, validators }

  describe '#receive' do
    it 'receives a message via interface' do
      expect(interface).to receive(:receive).and_return 'Response'

      expect(collector.send(:receive)).to eq 'Response'
    end
  end

  describe '#ask' do
    it 'sends and receives a message via interface' do
      expect(interface).to receive(:send).with 'Message'
      expect(interface).to receive(:receive).and_return 'Response'

      expect(collector.send(:ask, 'Message')).to eq 'Response'
    end
  end

  describe '#ask_yes_no' do
    it 'sends and receives a message via interface' do
      expect(interface).to receive(:send).with 'Message [yes/No]'
      expect(interface).to receive(:receive).and_return 'Yes'

      expect(collector.send(:ask_yes_no, 'Message')).to be_truthy
    end
  end

  describe '#ask_and_validate' do
    it 'sends and receives a message via interface' do
      expect(interface).to receive(:send).with 'Message'
      expect(interface).to receive(:receive).and_return 'something'
      expect(interface).to receive(:send).with 'Invalid email entered! Message'
      expect(interface).to receive(:receive).and_return 'john@doe.com'

      expect(collector.send(:ask_and_validate, 'Message', EmailValidator)).to eq 'john@doe.com'
    end
  end

  describe '#valid?' do
    context 'when there are no required_keys' do
      let(:required_keys) { %w[] }

      it 'returns true' do
        expect(collector.send(:valid?)).to be_truthy
      end
    end

    context 'when any of required_keys missing' do
      let(:required_keys) { %w[somekey something] }

      it 'returns false' do
        collector.instance_variable_set :@payload, somekey: 'somevalue'
        expect(collector.send(:valid?)).to be_falsey
      end
    end
  end

  describe '#collect' do
    let(:required_keys) { %i[somekey] }

    context 'with additional inputs' do
      it 'adds additional inputs to payload' do
        expect(collector).to receive(:ask).with('Enter key 1').and_return 'something'
        expect(collector).to receive(:ask).with('Enter something value').and_return 'somevalue'
        expect(collector).to receive(:ask).with('Enter key 2').and_return 'somekey'
        expect(collector).to receive(:ask).with('Enter somekey value').and_return 'somevalue'
        expect(collector).to receive(:ask_yes_no).with('Any additional inputs?').and_return true
        expect(collector).to receive(:ask).with('Enter key 3').and_return 'another'
        expect(collector).to receive(:ask).with('Enter another value').and_return 'somevalue'
        expect(collector).to receive(:ask_yes_no).with('Any additional inputs?').and_return false

        expect(collector.collect).to eq something: 'somevalue', somekey: 'somevalue', another: 'somevalue'
      end
    end

    it 'collects payload from user input until all the required keys set' do
      expect(collector).to receive(:ask).with('Enter key 1').and_return 'something'
      expect(collector).to receive(:ask).with('Enter something value').and_return 'somevalue'
      expect(collector).to receive(:ask).with('Enter key 2').and_return 'somekey'
      expect(collector).to receive(:ask).with('Enter somekey value').and_return 'somevalue'
      expect(collector).to receive(:ask_yes_no).with('Any additional inputs?').and_return false

      expect(collector.collect).to eq something: 'somevalue', somekey: 'somevalue'
    end
  end
end
