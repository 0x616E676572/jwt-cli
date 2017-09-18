#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/cli/app'

interface = Cli::CommandLine.new
collector = Cli::Collector.new interface, %i[email user_id], email: EmailValidator
app = Cli::App.new interface, collector
app.run
