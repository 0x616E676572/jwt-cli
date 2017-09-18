# frozen_string_literal: true

module Cli
  class Interface
    def send(_string)
      raise NotImplementedError
    end

    def receive
      raise NotImplementedError
    end
  end
end
