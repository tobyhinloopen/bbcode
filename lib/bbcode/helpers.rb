module Bbcode
	module Helpers
		def as_bbcode
			Base.new (@bbcode_parser ||= Parser.new(Tokenizer.new)), self.to_s
		end
	end
end