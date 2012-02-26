module Bbcode
	# An array with Elements and strings
	class NodeList < Array
		def initialize( handler, nodes = [] )
			super nodes
			@handler = handler
		end

		def source
			self.map{ |element| element.is_a?(String) ? element : element.source }.join
		end

		def to_s
			self.map{ |element| @handler.apply_element_handler_for_element element }.join
		end

		def with_handler( handler )
			NodeList.new handler, self
		end
	end
end