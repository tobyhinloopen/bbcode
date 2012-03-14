module Bbcode
	# Attempts to pair a stream of tokens created by a tokenizer
	class Parser < AbstractHandler
		attr_accessor :tokenizer

		def initialize( tokenizer = nil )
			@tags_stack = []
			self.tokenizer = tokenizer unless tokenizer.blank?
		end

		def tokenizer=( tokenizer )
			raise "#{tokenizer.inspect} appears not to be a valid tokenizer for it does not respond to :tokenize" unless tokenizer.respond_to?(:tokenize)
			@tokenizer = tokenizer
		end

		def text( text )
			@handler.text text
		end

		def start_element( tagname, attributes, source = nil )
			@tags_stack << tagname
			@handler.start_element tagname, attributes, source
		end

		def end_element( tagname, source = nil )
			return @tags_stack.last.blank? ? self.text(source) : end_element(@tags_stack.last, source) if tagname.blank?
			return self.text(source) unless @tags_stack.include?(tagname)

			@interruption_stack = []
			while @tags_stack.last != tagname do
				@interruption_stack << @tags_stack.last
				@handler.interrupt_element @tags_stack.pop
			end

			@handler.end_element @tags_stack.pop, source

			while !@interruption_stack.empty? do
				@tags_stack << @interruption_stack.last
				@handler.continue_element @interruption_stack.pop
			end
		end

		def parse( document, handler )
			@handler = handler
			@tokenizer.tokenize document, self
		end
	end
end