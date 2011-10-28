A BBCode parser designed for use with Ruby on Rails
===================================================
The parser is currently in active development and already is able to parse a
wide range of BBCode tags, but doesn't have any implementations to process them
into HTML yet.

Currently supported by parser:
------------------------------
* Regular bbcode tags like `[i]italic[/i]`
* Anonymous closing tags like `[b]bold[/]`
* Unnamed, comma-separated arguments like `[video=640, 480]...[/]`
* Named arguments as key=value or key:value pairs like
  `[table cellpadding=0 border:100]...[/]`
* Quoted arguments with escaped characters like
  `[abbr title='It\'s an example with a ] in it being ignored!']...[/]`

For a well-defined, up-to-date list of supported tags & syntaxes, check the
test's sources in the spec-folder.

Current known issues:
---------------------
None! (but a lot of stuff needs to be done)

How it will work:
-----------------
```ruby
msg = "[b]bold[/b] [color=red]red[/] [url=http://www.google.com/]google![/url]"

Bbcode::Base.register_handler :text, Bbcode::Handler.new({
	:url => ->(args, &block) { "#{block.call} (#{args[0]})" }
})
msg.as_bbcode.to(:text)
# => bold red google! (http://www.google.com/)

Bbcode::Base.register_handler :html, Bbcode::HtmlHandler.new({
	:b => :strong,
	:i => :em,
	:u => [ :span, { :class => "underline" } ]
	:url => ->(args, &block) {
		%(<a href="#{CGI.escapeHTML(args[0])}" target="#{CGI.escapeHTML(args[1] || "_blank")}">#{block.call}</a>)
	},
	:color => ->(args, &block) {
		%(<span style="color: #{CGI.escapeHTML(args[0])};">#{block.call}</span>)
	}
})
msg.as_bbcode.to(:html)
# => <strong>bold</strong> <span style="color: red;">red</spa> <a href="http://www.google.com/" target="_blank">google!</a>
```