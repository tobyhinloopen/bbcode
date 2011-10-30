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

		def source
			@handler_element.source
		end

		def content
			NodeList.new @handler_element.handler, @handler_element.childs.map{ |child_handler_element| child_handler_element.is_a?(String) ? child_handler_element : child_handler_element.element }
		end

		def to_s
			@handler_element.handler.get_element_handler(tagname).call(self)
		end
	end
end