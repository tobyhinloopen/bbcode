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
None!