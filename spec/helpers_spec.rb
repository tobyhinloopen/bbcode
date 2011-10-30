require 'spec_helper.rb'

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

Bbcode::Base.register_handler :html, handler
Bbcode::Base.register_handler :text, Bbcode::Handler.new()

describe Bbcode::Helpers do
	it "should enable a string to use a registered helper" do
		"test".as_bbcode.to(:text).should eql("test")
	end

	it "should enable a string to be parsed as bbcode" do
		"[b]bold[/]".as_bbcode.to(:html).should eql("<strong>bold</strong>")
	end
end