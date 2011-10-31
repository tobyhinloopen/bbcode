A BBcode parser designed to be used with Ruby on Rails
======================================================
A bbcode parser gem you can include in your rails app to parse bbcode-formatted
strings to HTML or any other format you like.

The bbcode gem consists of 4 parts:

- The `Tokenizer`-class, which converts the bbcode-formatted string to a stream
  of tokens.
- The `Parser`-class, which attempts to pair bbcode tags to bbcode elements.
- The `Handler`-class, which converts bbcode elements anyway you like.
- The `Helpers`-module, which adds a method to String, allowing you to convert
  bbcode-formatted strings with a registered handler.

Additionally, a `HtmlHandler` class is available. This class is a Handler
designed to convert bbcode elements to HTML more easily.

Installation:
-------------
Add the gem to the gemfile of your project.
(todo: add examples)

Usage:
------
Create and register a handler. In this example, I'm creating a HtmlHandler and
I'm going to register it as `:html`.

```ruby
Bbcode::Base.register_handler :html, Bbcode::HtmlHandler.new(
	:b => :strong,
	:i => :em,
	:url => [ :a, { :href => "%{0}" } ],
	:txt => ->(element){ "#{element.content.source}" },
	:img => ->(element){ %(<img src="#{CGI.escapeHTML(element.content.source)}">) },
	:color => [ :span, { :style => "color: %{0};" } ]
)
```

That's it! You can now parse any string as bbcode and convert it to html with
the `:html`-handler like this:

```ruby
"[b]Hello, bold world![/]".as_bbcode.to :html
# => <strong>Hello, bold world!</strong>
```

If you're using this gem in a rails project, I would recommend registering your
handlers in an initializer.

See examples in `spec/` folder for detailed examples of usage.

Features:
---------
See examples in `spec/` folder for list of working features.
(todo: add list of features)

Todo:
-----
An easier way to handle text around bbcode tags to, for example, add smileys
and wrap hyperlinks to URLs. Currently, the only way to achieve this is by
adding a `:"#text"`-handler to your handler and adding the functionality
yourself.

Known issues:
-------------
None.