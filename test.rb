# This is most likely not the best way to test a gem, but I'm too lazy to
# figure out how to test gems.

class String
	def scan(regexp, &block)
		offset = 0
		while !(match = self.match regexp, offset).nil?
			block.call *match
			offset = match.begin(0) + match[0].length
		end
	end
end

$LOAD_PATH << './lib'
require "bbcode.rb"

bbcode_parser = Bbcode::Parser.new

bbcode_parser.parse "[b]vet[i] en schuin[/b] maar niet vet[/i] of schuin\
[url=http://www.google.com/, _blank]text[/url]
[table width = 600 height=300 background-color=\"black\" background-image=url('ding')][/table]
[alt ding: 1, banana: 2]", do |event, *args|
	puts "#{event} #{args.map(&:inspect).join " "}"
end