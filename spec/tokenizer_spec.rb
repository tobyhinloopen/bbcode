require 'spec_helper.rb'

def get_tokenizer_results(string, strip_source = true)
	tokenizer = Bbcode::Tokenizer.new
	results = []
	tokenizer.tokenize string do |*args|
		args.pop if strip_source && [:end_element, :start_element].include?(args.first) # pop the source
		results.push args
	end
	results
end

describe Bbcode::Tokenizer do
	it "should parse a simple bbcode tag" do
		get_tokenizer_results("[b]")[0].should eql([:start_element, :b, {}])
	end

	it "should provide the actual source of the bbcode tag" do
		get_tokenizer_results("[b a = 1, b:2, c='1'][/][url=http://www.google.com/][/url]", false).should \
			eql([ [ :start_element, :b, { :a => "1", :b => "2", :c => "1" }.with_indifferent_access, "[b a = 1, b:2, c='1']"],
			      [ :end_element, nil, "[/]" ],
			      [ :start_element, :url, { 0 => "http://www.google.com/" }, "[url=http://www.google.com/]" ],
			      [ :end_element, :url, "[/url]" ] ])
	end

	it "should parse 4 simple bbcode tags with text" do
		get_tokenizer_results("[b]bold[i]and italic[/b]but not bold anymore[/i]nor italic")
	end

	it "should process text before the first bbcode tag" do
		get_tokenizer_results("text[b]")[0].should eql([:text, "text"])
	end

	it "should process text after the last bbcode tag" do
		get_tokenizer_results("[b]text")[1].should eql([:text, "text"])
	end

	it "should parse an anonymous closing tag" do
		get_tokenizer_results("[/]")[0].should eql([:end_element, nil])
	end

	it "should parse a single, regular unnamed argument" do
		get_tokenizer_results("[url=http://www.google.com/]")[0].should \
			eql([:start_element, :url, { 0 => "http://www.google.com/" }])
	end

	it "should parse a quoted, unnamed argument without the equals-to sign" do
		get_tokenizer_results("[url'http://www.google.nl/']")[0].should \
			eql([:start_element, :url, { 0 => "http://www.google.nl/" }])
	end

	it "should parse multiple unnamed arguments" do
		get_tokenizer_results("[video=640, 480,,1]")[0].should \
			eql([:start_element, :video, { 0 => "640", 1 => "480", 3 => "1" }]);
	end

	it "should parse quoted unnamed arguments with escaped characters" do
		get_tokenizer_results(%([abbr='It\\'s a test', "...a \\"test\\"!"]))[0].should \
			eql([:start_element, :abbr, { 0 => "It's a test", 1 => '...a "test"!' }])
	end

	it "should parse quoted named arguments with escaped characters" do
		get_tokenizer_results(%([abbr a='It\\'s a test', b: "...a \\"test\\"!"]))[0].should \
			eql([:start_element, :abbr, { :a => "It's a test", :b => '...a "test"!' }.with_indifferent_access])
	end

	it "should ignore the quotes of an attribute value if the quote-pair is incomplete or incorrect" do
		get_tokenizer_results(%([a "test]))[0].should eql([:start_element, :a, { 0 => "\"test" }])
	end

	it "should parse key=value attribute pairs" do
		get_tokenizer_results(%([table=list width = 600 height=300 background-color= \"black\" background-image =url('image.jpg')]))[0].should \
			eql([:start_element, :table, { 0 => "list", :width => "600", :height => "300", :"background-color" => "black", :"background-image" => "url('image.jpg')" }.with_indifferent_access])
	end

	it "should parse key:value attribute pairs separated with optional comma" do
		get_tokenizer_results(%([alt ding: a, banana: b]))[0].should \
			eql([:start_element, :alt, { :ding => "a", :banana => "b" }.with_indifferent_access])
	end

	it "should ignore the ] in the attribute value" do
		get_tokenizer_results(%([testing "with a ] in my attribute!"])).should \
			eql([[:start_element, :testing, { 0 => "with a ] in my attribute!" }]])
	end
end