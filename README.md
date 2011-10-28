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
  `[abbr font="Arial, Verdana, \"Courier new\"" title='It\'s an example!']...[/]`

Current known issues:
---------------------
* Arguments cannot contain a "]" character, even when escaped in a quoted
  argument value. For example, parsing `[data="te]st"]` will only parse a
  bbcode tag `data` with as first argument `"te`. The final `st"]` will be
  considered text.