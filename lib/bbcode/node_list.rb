module Bbcode
	# An array with Elements and strings
	class NodeList < Array
		def to_s
			self.join
		end
	end
end