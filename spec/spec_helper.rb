require 'rubygems'
require 'bundler/setup'

require 'bbcode'

class DummyHandler
	attr_accessor :stack

	def initialize(strip_source)
		@strip_source = strip_source
	end

	def method_missing(*args)
		(@stack ||= []) << args.tap{ |args| args.pop if @strip_source && args.first.to_s.end_with?("element") }
	end
end

RSpec.configure do |config|
  # some (optional) config here
end