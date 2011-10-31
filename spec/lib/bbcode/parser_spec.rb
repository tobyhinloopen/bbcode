require 'spec_helper.rb'

class BlockHandler
	def initialize( block )
		@block = block
	end

	def method_missing(*args)
		@block.call *args
	end
end

def get_parser_results(string, strip_source = true)
	parser = Bbcode::Parser.new Bbcode::Tokenizer.new
	results = []
	parser.parse string, BlockHandler.new(->(*args) {
		args.pop if strip_source && [:end_element, :start_element].include?(args.first) # pop the source
		results.push args
	})
	results
end

describe Bbcode::Parser do
	it "should parse text without bbcode" do
		get_parser_results("Hello, world!")[0].should eql([:text, "Hello, world!"])
	end

	it "should parse a simple bbcode element" do
		get_parser_results("[b]text[/b]").should \
			eql([ [ :start_element, :b, {} ],
			      [ :text, "text" ],
			      [ :end_element, :b ] ])
	end

	it "should parse a simple bbcode element with shorthand closing tag" do
		get_parser_results("[b]text[/]").should \
			eql([ [ :start_element, :b, {} ],
			      [ :text, "text" ],
			      [ :end_element, :b ] ])
	end

	it "should provide the actual sourcecode of the elements" do
		get_parser_results("[b a = 1, b:2, c='1'][/][url=http://www.google.com/][/url]", false).should \
			eql([ [ :start_element, :b, { :a => "1", :b => "2", :c => "1" }.with_indifferent_access, "[b a = 1, b:2, c='1']"],
			      [ :end_element, :b, "[/]" ],
			      [ :start_element, :url, { 0 => "http://www.google.com/" }, "[url=http://www.google.com/]" ],
			      [ :end_element, :url, "[/url]" ] ])
	end

	it "should fire an interrupt for incorrect nested elements" do
		get_parser_results("[b]bold[i]and italic[/b]but not bold[/i]nor italic").should \
			eql([ [ :start_element, :b, {} ],
			      [ :text, "bold" ],
			      [ :start_element, :i, {} ],
			      [ :text, "and italic" ],
			      [ :interrupt_element, :i ],
			      [ :end_element, :b ],
			      [ :continue_element, :i ],
			      [ :text, "but not bold" ],
			      [ :end_element, :i ],
			      [ :text, "nor italic" ] ])
	end

	it "should fire multiple interrupts for multiple incorrect nested elements" do
		get_parser_results("[u]a[b]b[i]c[/u]d[/i]e[/b]").should \
			eql([ [ :start_element, :u, {} ],
			      [ :text, "a" ],
			      [ :start_element, :b, {} ],
			      [ :text, "b" ],
			      [ :start_element, :i, {} ],
			      [ :text, "c" ],
			      [ :interrupt_element, :i ],
			      [ :interrupt_element, :b ],
			      [ :end_element, :u ],
			      [ :continue_element, :b ],
			      [ :continue_element, :i ],
			      [ :text, "d" ],
			      [ :end_element, :i ],
			      [ :text, "e" ],
			      [ :end_element, :b ]])
	end
end