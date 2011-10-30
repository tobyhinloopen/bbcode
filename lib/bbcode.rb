require "bbcode/version"
require "bbcode/tokenizer"
require "bbcode/parser"
require "bbcode/handler"
require "bbcode/html_handler"
require "bbcode/base"
require "bbcode/helpers"

module Bbcode
	String.send :include, Bbcode::Helpers
end