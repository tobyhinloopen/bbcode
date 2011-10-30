module Bbcode
	module Helpers
		def as_bbcode
			Base.new self.to_s
		end
	end
end