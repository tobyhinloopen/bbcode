module Bbcode
	class Base
		@@handlers = HashWithIndifferentAccess.new

		attr_reader :locals

		def initialize(string, locals = {})
			@string = string
		end

		def to(handler, locals = {})
			handler = @@handlers[handler]
			raise "Handler #{handler} isn't registered" if handler.blank?
			handler.locals = locals.with_indifferent_access
			Parser.new(Tokenizer.new).parse @string, handler
			result = handler.get_document.content.to_s
			handler.clear
			result
		end

		def self.register_handler(name, handler)
			@@handlers[name] = handler
		end
	end
end