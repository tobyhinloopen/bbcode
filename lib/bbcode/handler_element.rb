require "bbcode/element"

module Bbcode
	# Private data source for an Element updated by the Handler
	class HandlerElement
		attr_accessor :childs
		attr_reader :element, :tagname, :attributes, :handler

		def initialize( handler, tagname, attributes, start_source )
			@handler = handler
			@tagname = tagname
			@attributes = attributes
			@start_source = start_source
			@end_source = nil
			@childs = []
			@element = Element.new(self)
		end

		def end_element( source )
			@end_source = source
		end

		def source
			"#{@start_source}#{@element.content.source}#{@end_source}"
		end
	end
end