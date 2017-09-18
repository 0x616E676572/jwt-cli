# frozen_string_literal: true

module Cli
  class Collector
    def initialize(interface, required_keys, validators)
      @interface = interface
      @required_keys = required_keys
      @validators = validators
      @payload = {}
      @num = 0
    end

    def collect
      until valid? && !ask_yes_no('Any additional inputs?')
        @num += 1
        key = ''
        key = ask("Enter key #{@num}").to_sym while key.empty?
        value = ask_and_validate "Enter #{key} value", @validators[key]

        @payload[key] = value
      end
      @payload
    end

    private

    def ask(prompt)
      @interface.send prompt
      receive
    end

    def ask_yes_no(prompt, default = false)
      value = ''
      default_value = default ? 'yes' : 'no'
      label = default ? '[Yes/no]' : '[yes/No]'

      until %w[yes no].include? value
        value = ask(prompt + ' ' + label).downcase
        value = default_value if value.empty?
      end

      value == 'yes'
    end

    def ask_and_validate(prompt, validator)
      value = ''
      error = nil

      loop do
        value = ask [error, prompt].reject(&:nil?).join ' '
        error = validator.validate value if validator
        break if !value.empty? && error.nil?
      end

      value
    end

    def receive
      @interface.receive
    end

    def valid?
      (@required_keys - @payload.keys).empty?
    end
  end
end
