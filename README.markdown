Fabulator Grammar Extension
---------------------------

This extension provides basic support for regular expressions modeled
loosely after [Perl 6 grammars][].

For now, this extension provides a single function: 'match(regex, string)'.  
This function returns true or false depending on whether or not the regular
expression matches the given string.

The current implementation compiled regular expressions into Ruby
RegExp objects for faster execution.  This may change as new capabilities
are added that might not be supportable by pure Ruby regular expressions.

The goal of the grammar extension is to provide a rich environment for
writing parsers that can be integrated into the Fabulator environment.

Regular Expressions
===================

The following characters are considered special and should be escaped if
you are not using for their special meaning:

  Parenthesis    ( )
  Brackets       [ ]
  Curly Brackets { }
  Angle Brackets < >
  Dot            .
  Question       ?
  Caret          ^
  Dollar         $
  Asterisk       *
  Plus           +
  

Additionally, the hyphen '-' should be the first character in a character
class if it is matching itself instead of indicated a range.  It can not
be used as either the beginning or end of a range at present.

Whitespace can separate tokens in the regular expression, but the amount of
Whitespace is not significant.  All tokens assume the possible existance of
whitespace in the string being matched and will not fail due to the
whitespace being there.

[Perl 6 grammars]: http://feather.perl6.nl/syn/S05.html
