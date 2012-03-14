require "bbcode/handler_element"

module Bbcode
	class Handler < AbstractHandler
		attr_accessor :element_handlers, :locals

		def initialize( element_handlers = nil )
			@element_handlers = {}.with_indifferent_access
			@handler_element_stack = []
			self.clear
			register_element_handlers element_handlers unless element_handlers.blank?
			@interruption_stack = []
			self.locals = {}
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
			# TODO: Add better way to handle interrupts
			@interruption_stack << current_handler_element
			end_element tagname, ""
		end

		def continue_element( tagname )
			# TODO: Add better way to handle interrupts
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

		def clear
			@handler_element_stack.clear
			@handler_element_stack << HandlerElement.new( self, :"#document", {}, "" )
		end

		def get_element_handler( name )
			@element_handlers[name] || ->(element){ element.is_a?(String) ? element : element.source_wraps_content }
		end

		def locals=(locals)
			@locals = locals.with_indifferent_access
		end

		def apply_element_handler_for_element(element)
			callable = get_element_handler(element.is_a?(String) ? :"#text" : element.tagname)
			callable.arity == 2 ? callable.call(element, locals) : callable.call(element)
		end

		protected
		def current_handler_element
			@handler_element_stack.last
		end
	end
end