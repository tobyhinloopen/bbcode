require 'spec_helper.rb'

def get_handled_parser_result( string )
	handler = Bbcode::Handler.new({
		:b => ->(element){ "<strong>#{element.content}</strong>" },
		:i => ->(element){ "<em>#{element.content}</em>" },
		:"#text" => ->(text){ CGI.escapeHTML(text) }
	})
	parser = Bbcode::Parser.new Bbcode::Tokenizer.new
	parser.parse string, &handler.get_parser_handler
	handler.get_document.content
end

describe Bbcode::Handler do
	it "should handle text without bbcode" do
		get_handled_parser_result("Hello, World!").should eql("Hello, World!")
	end

	it "should handle the text handler" do
		get_handled_parser_result("&").should eql("&amp;")
	end

	it "should handle a bbcode tag" do
		get_handled_parser_result("[b]bold[/]").should eql("<strong>bold</strong>")
	end

	it "should handle nested bbcode tags" do
		get_handled_parser_result("[b]bold and [i]italic[/][/]").should \
			eql("<strong>bold and <em>italic</em></strong>")
	end
end