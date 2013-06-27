require 'active_support/all'
require 'action_view/helpers/capture_helper'
require 'action_view/helpers/tag_helper'
require 'cgi'
require "bbcode/version"
require "bbcode/tokenizer"
require "bbcode/abstract_handler"
require "bbcode/parser"
require "bbcode/handler"
require "bbcode/html_handler"
require "bbcode/base"
require "bbcode/helpers"

module Bbcode
	String.send :include, Bbcode::Helpers

	def self.handlers
		@@handlers ||= {}
	end

	def self.handler(name)
		handlers[name]
	end

	def self.register_handler(name, handler)
		handlers[name] = handler
	end

	def self.parsers
		@@parsers ||= {}
	end

	def self.parser(name)
		parser = parsers[name]
		parser.respond_to?(:call) ? parser.call : parser
	end

	def self.register_parser(name, parser = nil, &parser_factory)
		parsers[name] = (parser || parser_factory)
	end

	register_parser(:bbcode){ Parser.new(Tokenizer.new) }
end