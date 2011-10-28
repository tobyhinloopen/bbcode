require 'spec_helper.rb'

describe Bbcode::Parser do
	it "test" do
		Bbcode::Parser.new.class.should eql("1")
	end
end