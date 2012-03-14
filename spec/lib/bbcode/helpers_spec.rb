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
	:admin => ->(element, locals){ locals[:is_admin] ? element.content : "" },
	:"#text" => ->(text){ CGI.escapeHTML(text) }
})

quote_handler.register_element_handlers handler.element_handlers.merge({
	:img => ->(element){ %(<a href="#{element.content.source}">image</a>) },
	:quote => ->(element){ "[...]" }
})

Bbcode.register_handler :html, handler
Bbcode.register_handler :text, Bbcode::Handler.new

describe Bbcode::Helpers do
	it "should enable a string to use a registered helper" do
		"test".as_bbcode.to(:text).should eql("test")
	end

	it "should be able to parse for a second time without being affected by the first" do
		"test 2".as_bbcode.to(:text).should eql("test 2")
	end

	it "should enable a string to be parsed as bbcode" do
		"[b]bold[/]".as_bbcode.to(:html).should eql("<strong>bold</strong>")
	end

	it "should be able to process non-ascii characters" do
		# load UTF-8 content from a file and parse it
	end

	it "should be able to pass locals" do
		"[admin]Only admins can see this![/]".as_bbcode.to(:html, :is_admin => true).should eql("Only admins can see this!")
		"[admin]Only admins can see this![/]".as_bbcode.to(:html, :is_admin => false).should eql("")
	end
end