module Bbcode
	class AbstractHandler
		def start_element(tagname, attributes = {}, source = nil); end
		def end_element(tagname, source = nil); end
		def text(text); end
		def interrupt_element(tagname); end
		def continue_element(tagname); end

		def restart_element(tagname, attributes = {}, source = nil)
			end_element tagname
			start_element tagname, attributes, source
		end

		def void_element(tagname, attributes = {}, source = nil)
			start_element tagname, attributes, source
			end_element tagname
		end

		def result(); end
	end
end
