module Bbcode
	# Attempts to pair a stream of tokens created by a tokenizer
	class Parser
		attr_accessor :tokenizer

		def initialize( tokenizer = nil )
			self.tokenizer = tokenizer unless tokenizer.blank?
		end

		def tokenizer=( tokenizer )
			raise "#{tokenizer.inspect} appears not to be a valid tokenizer for it does not respond to :tokenize" unless tokenizer.respond_to?(:tokenize)
			@tokenizer = tokenizer
		end

		def start_document
			@tags_stack = []
			@handler.call :start_document
		end

		def end_document
			@tags_stack = nil
			@handler.call :end_document
		end

		def text( text )
			@handler.call :text, text
		end

		def start_element( tagname, attributes, source )
			@tags_stack << tagname
			@handler.call :start_element, tagname, attributes, source
		end

		def end_element( tagname, source )
			return @tags_stack.last.blank? ? self.text(source) : end_element(@tags_stack.last, source) if tagname.blank?
			return self.text(source) unless @tags_stack.include?(tagname)

			# if last_tagname != tagname
			# 				@interruption_stack = []
			# 				while last_tagname != tagname do
			# 					@interruption_stack << last_tagname
			# 					last_tagname = @tags_stack.pop
			# 				end
			# 			end

			@handler.call :end_element, @tags_stack.pop, source
		end

		def parse( document, &handler )
			@handler = handler
			@tokenizer.tokenize document do |*args|
				self.send *args if [:start_document, :end_document, :start_element, :end_element, :text].include?(args.first)
			end
		end
	end
end