module Bbcode
	# An array with Elements and strings
	class NodeList < Array
		def initialize(parent, nodes = [])
			super nodes
			@parent = parent
		end

		def source
			self.map{ |element| element.is_a?(String) ? element : element.source }.join
		end

		def to_s
			self.map{ |element|
				element.is_a?(String) \
					? @parent.handler.get_element_handler(:"#text").call(element) \
					: element.to_s
			}.join
		end
	end
end