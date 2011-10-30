require 'spec_helper.rb'

def get_handled_parser_result( string )
	quote_handler = Bbcode::Handler.new()

	handler = Bbcode::Handler.new({
		:b => ->(element){ "<strong>#{element.content}</strong>" },
		:i => ->(element){ "<em>#{element.content}</em>" },
		:url => ->(element){ %(<a href="#{CGI.escapeHTML(element[0])}">#{element.content}</a>) },
		:txt => ->(element){ "#{element.content.source}" },
		:img => ->(element){ %(<img src="#{element.content.source}">) },
		:quote => ->(element){ %(<blockquote>#{element.content.with_handler(quote_handler)}</blockquote>) },
		:color => ->(element){ %(<span style="color: #{CGI.escapeHTML(element[0])};">#{element.content}</span>) },
		:"#text" => ->(text){ CGI.escapeHTML(text) }
	})

	quote_handler.register_element_handlers handler.element_handlers.merge({
		:img => ->(element){ %(<a href="#{element.content.source}">image</a>) },
		:quote => ->(element){ "[...]" }
	})

	parser = Bbcode::Parser.new Bbcode::Tokenizer.new
	parser.parse string, &handler.get_parser_handler
	"#{handler.get_document.content}"
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

	it "should ignore unregistered elements" do
		get_handled_parser_result("[foo]text[/foo]").should eql("[foo]text[/foo]")
	end

	it "should handle bbcode inside an ignored element" do
		get_handled_parser_result("[foo][b]bold[/b][/foo]").should eql("[foo]<strong>bold</strong>[/foo]")
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

	it "should resend attributes in tag interrupts" do
		get_handled_parser_result("[b]bold[color=red]and red[/b]but not bold[/]").should \
			eql(%(<strong>bold<span style="color: red;">and red</span></strong><span style="color: red;">but not bold</span>))
	end

	it "should be able to render the source of an element's contents" do
		get_handled_parser_result("[txt][b]ignored element[/b][/txt]").should \
			eql("[b]ignored element[/b]")
	end

	it "should be able to switch handlers" do
		get_handled_parser_result("[quote][img]epic.jpg[/img][/quote][img]epic.jpg[/img]").should \
			eql(%(<blockquote><a href="epic.jpg">image</a></blockquote><img src="epic.jpg">))
	end
end