require 'spec_helper.rb'

def get_parser_results(string)
	parser = Bbcode::Parser.new
	results = []
	parser.parse string, do |*args|
		results.push args
	end
	results[1...-1]
end

describe Bbcode::Parser do

	it "should parse a simple bbcode tag" do
		get_parser_results("[b]")[0].should eql([:start_element, :b, {}])
	end

	it "should process text before the first bbcode tag" do
		get_parser_results("text[b]")[0].should eql([:text, "text"])
	end

	it "should process text after the last bbcode tag" do
		get_parser_results("[b]text")[1].should eql([:text, "text"])
	end

	it "should parse an anonymous closing tag" do
		get_parser_results("[/]")[0].should eql([:end_element, nil])
	end

	it "should parse a single, regular unnamed argument" do
		get_parser_results("[url=http://www.google.com/]")[0].should eql([:start_element, :url, { 0 => "http://www.google.com/" }])
	end

	it "should parse multiple unnamed arguments" do
		get_parser_results("[video=640, 480,,1]")[0].should eql([:start_element, :video, { 0 => "640", 1 => "480", 3 => "1" }]);
	end

	it "should parse a quoted argument with escaped characters" do
		get_parser_results(%([abbr='It\\'s a test', "...a \\"test\\"!"]))[0].should eql([:start_element, :abbr, { 0 => "It's a test", 1 => '...a "test"!' }])
	end
end

# [b]vet[i] en schuin[/b] maar niet vet[/i] of schuin\
# [url=http://www.google.com/, _blank]text[/url]
# [table width = 600 height=300 background-color=\"black\" background-image=url('ding')][/table]
# [alt ding: 1, banana: 2]