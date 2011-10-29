require "bbcode/node_list"

module Bbcode
	class Element
		def initialize( handler_element )
			@handler_element = handler_element
		end

		def tagname
			@handler_element.tagname
		end

		def attributes
			@handler_element.attributes
		end

		def []( key )
			@handler_element.attributes[key]
		end

		def content
			@handler_element.childs.map{ |child_handler_element|
				child_handler_element.is_a?(String) \
					? @handler_element.handler.get_element_handler(:"#text").call(child_handler_element) \
					: child_handler_element.handler.get_element_handler(child_handler_element.tagname).call(child_handler_element.element)
			}.join
		end

		def child_nodes
			NodeList.new @handler_element.childs.map{ |child_handler_element| child_handler_element.is_a?(String) ? child_handler_element : child_handler_element.element }
		end

		def as_bbcode
			NodeList.new [self]
		end

		def to_s
			@handler_element.source
		end
	end
end