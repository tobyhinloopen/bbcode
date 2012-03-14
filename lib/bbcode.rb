require 'active_support/all'
require 'action_view/helpers/capture_helper'
require 'action_view/helpers/tag_helper'
require 'cgi'
require "bbcode/version"
require "bbcode/tokenizer"
require "bbcode/parser"
require "bbcode/handler"
require "bbcode/html_handler"
require "bbcode/base"
require "bbcode/helpers"

include ActionView::Helpers::TagHelper

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
end