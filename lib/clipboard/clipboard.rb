# frozen_string_literal: true

module Clipboard
  def self.copy(string)
    case RUBY_PLATFORM
    when /darwin/
      system("echo '#{string}' | pbcopy")
    else
      raise NotImplementedError
    end
  end
end
