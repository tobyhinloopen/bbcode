A BBcode parser designed to be used with Ruby on Rails
=======================================================
A bbcode parser gem you can include in your rails app to parse bbcode-formatted
strings to HTML or any other format you like.

The bbcode gem consists of 4 parts:
* A Tokenizer, which converts the bbcode-formatted string to a stream of tokens
* A Parser, which attempts to pair bbcode tags to bbcode elements
* A Handler, which converts bbcode elements anyway you like
* A Helpers-module, which adds a method to String, allowing you to convert
  bbcode-formatted strings with a registered handler.

Additionally, a HtmlHandler class is available. This class is a Handler
designed to convert bbcode elements to HTML more easily.

Installation
------------
Add the gem to the gemfile of your project.
(todo: add examples)

Usage
-----
Create and register a handler. In this example, I'm creating a HtmlHandler and
I'm going to register it as `:html`.

```ruby
Bbcode::Base.register_handler :html, Bbcode::HtmlHandler.new(
	:b => :strong,
	:i => :em,
	:url => [ :a, { :href => "%{0}" } ],
	:txt => ->(element){ "#{element.content.source}" },
	:img => ->(element){ %(<img src="#{element.content.source}">) },
	:quote => ->(element){ %(<blockquote>#{element.content.with_handler(quote_handler)}</blockquote>) },
	:color => [ :span, { :style => "color: %{0};" } ]
)
```

That's it! You can now parse any string as bbcode and convert it to html with
the `:html`-handler like this:

```ruby
"[b]Hello, bold world![/]".as_bbcode.to :html
# => <strong>Hello, bold world!</strong>
```

Features
--------
(todo: add list of features)