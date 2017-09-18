# frozen_string_literal: true

module Cli
  class CommandLine
    def send(string)
      STDOUT.puts(string)
    end

    def receive
      value = STDIN.gets
      value.nil? ? '' : value.chomp
    end
  end
end
