require "bbcode/handler"

module Bbcode
	class HtmlHandler < Handler
		include ActionView::Helpers::TagHelper
			
		def initialize( element_handlers = nil )
			super :"#text" => ->(text){ CGI.escapeHTML(text) }
			register_element_handlers element_handlers unless element_handlers.nil?
		end

		def register_element_handler( name, handler )
			unless handler.is_a?(Proc)
				target_tagname, attributes = handler.is_a?(Array) ? handler : [handler, {}]
				handler = ->(element){
					content_tag(target_tagname, element.content, !attributes ? {} : Hash[attributes.map{ |k, v|
						[k, v.gsub(/%{[^}]+}/) { |m| CGI.escapeHTML element[m[3] == ":" ? m[3...-1].to_sym : m[2...-1].to_i].to_s }]
					}], false)
				}
			end
			super name, handler
		end
	end
end