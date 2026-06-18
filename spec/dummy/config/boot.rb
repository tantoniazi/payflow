# frozen_string_literal: true

begin
  require "bundler/setup"
rescue LoadError
  puts "Bundler setup failed."
end

require "payflow"
require "payflow/version"
