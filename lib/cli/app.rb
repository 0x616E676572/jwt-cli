# frozen_string_literal: true

require 'jwt'
require_relative 'collector'
require_relative 'command_line'
require_relative '../clipboard/clipboard'

class EmailValidator
  def self.validate(value)
    'Invalid email entered!' unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match? value
  end
end

module Cli
  class App
    def initialize(interface, collector)
      @interface = interface
      @collector = collector
    end

    def run
      payload = @collector.collect

      begin
        token = JWT.encode payload, 'my$ecretK3y', 'HS256'
      rescue StandardError
        @interface.send 'There was a problem creating token'
        return
      end

      begin
        Clipboard.copy token
        @interface.send 'The JWT has been copied to your clipboard!'
      rescue NotImplementedError
        @interface.send 'Cannot copy token due to unsupported platform'
      end
    end
  end
end
