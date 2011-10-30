A BBCode parser designed for use with Ruby on Rails
===================================================
This documentation is somewhat outdated. Check tests in spec-folder for usage
examples. `handler_spec.rb` currently features the most high-level usage.

Currently supported by parser:
------------------------------
* Regular bbcode tags like `[i]italic[/i]`
* Incorrect nesting of tags like `[b]bold[i]and italic[/b]but not bold[/i]`
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


How it will work:
-----------------
```ruby
msg = "[b]bold[/b] [color=red]red[/] [url=http://www.google.com/]google![/url]"

Bbcode::Base.register_handler :text, Bbcode::Handler.new({
	:url => ->(args, content) { "#{content} (#{args[0]})" }
})
msg.as_bbcode.to(:text)
# => bold red google! (http://www.google.com/)

Bbcode::Base.register_handler :html, Bbcode::HtmlHandler.new({
	:b => :strong,
	:i => :em,
	:u => [ :span, { :class => "underline" } ]
	:url => ->(args, content) {
		%(<a href="#{CGI.escapeHTML(args[0])}" target="#{CGI.escapeHTML(args[1] || "_blank")}">#{content}</a>)
	},
	:color => ->(args, content) {
		%(<span style="color: #{CGI.escapeHTML(args[0])};">#{content}</span>)
	},
	:code => ->(args, content) {
		%(<pre>#{content.as_bbcode}</pre>)
	}
})
msg.as_bbcode.to(:html)
# => <strong>bold</strong> <span style="color: red;">red</spa> <a href="http://www.google.com/" target="_blank">google!</a>
```

`as_bbcode` will convert an object to a bbcode node-set which can be rendered
as plain-text or can be handled by a bbcode handler.

`content` is a bbcode node-set in a wrapper, enabling you to either render the
node-set to a string by using the current handler by using `to_s`, or extract
the node-set to print the plain bbcode content or use another handler to render
the node-set.

Nested handlers:
----------------
You can customize the behavior of the handler within different bbcode tags. For
example, you could use a different html handler to convert a quote's content.
If a quoted message contains images, video's or other quotes, you might want to
strip the nested quotes and skip the rendering of the image/video and render a
link to the image/video instead.

```ruby
msg = "[quote]\
[img]funpic.jpg[/]\
[/]\
[img]zomg.jpg[/] epic image!"

Bbcode::Base.register_handler :quote_html, Bbcode::HtmlHandler.new({
	:img => ->(args, content) {
		%(<a href="#{content.as_bbcode}" target="_blank">image</a>)
	},
	:quote => ->(args, content) { "[...]" }
})

Bbcode::Base.register_handler :html, Bbcode::HtmlHandler.new({
	:img => ->(args, content) { %(<img src="#{content.as_bbcode}">) }
	:quote => ->(args, content) { %(<blockquote>#{content.as_bbcode.to(:quote_html)}</blockquote>) }
})

msg.as_bbcode.to(:html)
# => <blockquote>
# => <a href="funpic.jpg" target="_blank">image</a>
# => </blockquote>
# => <img src="zomg.jpg"> epic image!
```