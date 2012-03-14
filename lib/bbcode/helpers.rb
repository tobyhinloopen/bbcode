module Bbcode
	module Helpers
		def parse_with(parser)
			Base.new parser, self.to_s
		end

		def as(parser_name)
			parse_with Bbcode.parser parser_name
		end

		def as_bbcode
			as :bbcode
		end
	end
end