module Bbcode
	class Base
		@@handlers = {}.with_indifferent_access

		def initialize( string )
			@string = string
		end

		def to( handler )
			handler = @@handlers[handler]
			raise "Handler #{handler} isn't registered" if handler.blank?
			Parser.new(Tokenizer.new).parse @string, &handler.get_parser_handler
			result = handler.get_document.content.to_s
			handler.clear
			result
		end

		def self.register_handler( name, handler )
			@@handlers[name] = handler
		end
	end
end