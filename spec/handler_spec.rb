require 'spec_helper.rb'

def get_handled_parser_result( string )
	handler = Bbcode::Handler.new({
		:b => ->(element){ "<strong>#{element.content}</strong>" },
		:i => ->(element){ "<em>#{element.content}</em>" },
		:url => ->(element){ %(<a href="#{CGI.escapeHTML(element[0])}">#{element.content}</a>) },
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

	it "should handle attributes in a bbcode tag" do
		get_handled_parser_result("[url=http://google.com/]google[/url]").should \
			eql(%(<a href="http://google.com/">google</a>))
	end

	it "should handle basic tag interrupts" do
		get_handled_parser_result("[b]bold[i]and italic[/b]only italic[/i]").should \
			eql("<strong>bold<em>and italic</em></strong><em>only italic</em>")
	end
end