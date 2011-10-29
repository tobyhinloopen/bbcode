require 'spec_helper.rb'

def get_parser_results(string, strip_start_and_end = true, strip_source = true)
	parser = Bbcode::Parser.new Bbcode::Tokenizer.new
	results = []
	parser.parse string do |*args|
		args.pop if strip_source && [:end_element, :start_element].include?(args.first) # pop the source
		results.push args
	end
	strip_start_and_end ? results[1...-1] : results
end

describe Bbcode::Parser do
	it "should send a start_document and end_document event" do
		get_parser_results("", false).should eql([[:start_document], [:end_document]])
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
		get_tokenizer_results("[b a = 1, b:2, c='1'][/][url=http://www.google.com/][/url]", true, false).should \
			eql([ [ :start_element, :b, { :a => "1", :b => "2", :c => "1" }.with_indifferent_access, "[b a = 1, b:2, c='1']"],
			      [ :end_element, nil, "[/]" ],
			      [ :start_element, :url, { 0 => "http://www.google.com/" }, "[url=http://www.google.com/]" ],
			      [ :end_element, :url, "[/url]" ] ])
	end
end