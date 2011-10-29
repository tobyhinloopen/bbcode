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
			@handler.call :start_document
		end

		def end_document
			@handler.call :end_element
		end

		def text( text )
			@handler.call :text, text
		end

		def start_element( tagname, attributes, source = nil )
			@last_tagname = tagname
		end

		def end_element( tagname = nil, source = nil )
			return @last_tagname.nil? ? self.text(source) : end_element(@last_tagname) if tagname.nil?
			
		end

		def parse( document, &handler )
			@handler = handler
			tokenizer.tokenize document, ->(*args){ self.send *args if [:start_document, :end_document, :start_element, :end_element, :text].include?(args.first) }
		end
	end
end