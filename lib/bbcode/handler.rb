require "bbcode/handler_element"

module Bbcode
	class Handler
		attr_accessor :element_handlers

		def initialize( element_handlers = nil )
			@element_handlers = {}.with_indifferent_access
			@handler_element_stack = [ HandlerElement.new( self, :"#document", {}, "" ) ]
			register_element_handlers element_handlers unless element_handlers.blank?
			@interruption_stack = []
		end

		def register_element_handlers( element_handlers )
			element_handlers.each do |k, v|
				register_element_handler k, v
			end
		end

		def register_element_handler( name, handler )
			@element_handlers[name] = handler
		end

		def start_element( tagname, attributes, source )
			handler_element = HandlerElement.new self, tagname, attributes, source
			current_handler_element.childs << handler_element
			@handler_element_stack << handler_element
		end

		def interrupt_element( tagname )
			@interruption_stack << current_handler_element
			end_element tagname, ""
		end

		def continue_element( tagname )
			handler_element = @interruption_stack.pop
			start_element handler_element.tagname, handler_element.attributes, ""
		end

		def end_element( tagname, source )
			raise "Unexpected end of #{tagname.inspect}, expected #{current_handler_element.tagname.inspect}" if tagname != current_handler_element.tagname
			current_handler_element.end_element source
			@handler_element_stack.pop
		end

		def text( text )
			current_handler_element.childs << text
		end

		def get_document
			@handler_element_stack.first.element
		end

		# DEPRECATED: Parse should be able to use Bbcode::Handler instances
		def get_parser_handler
			->(*args) {
				current_handler_element.handler.send *args if [:start_element, :interrupt_element, :continue_element, :end_element, :text].include?(args.first)
			}
		end

		def get_element_handler( name )
			@element_handlers[name] || ->(element){ element.is_a?(String) ? element : element.content }
		end

		protected
		def current_handler_element
			@handler_element_stack.last
		end
	end
end