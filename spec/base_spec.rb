require 'spec_helper.rb'

describe Bbcode::Base do
	it "should enable a handler to be registered and used" do
		Bbcode::Base.register_handler :test, Bbcode::Handler.new
		Bbcode::Base.new("test").to(:test).should eql("test")
	end
end