Feature: Basic regex parsing

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (foo)
   Then it should match "foo"

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (foo+)
   Then it should match "foo"
    And it should match "foooo"
    And it should not match "fo"

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (foo+?)
   Then it should match "fooooooo"

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (foo{1,4}$)
   Then it should match "foo"
   Then it should match "fooooo"
   Then it should not match "foooooo"
   Then it should not match "fo"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (^[Ff]o[-a-zA-F01234-9]+?)
   Then it should match "foo"
    And it should match "Foo"
    And it should match "FoF03z-"
    And it should not match "hellofoo"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex ([\[-\]]o[a-z\]A-F01234-9]+?)

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (<foo><g:bar>*)

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (bar ( <foo> <g:bar> ) *)

  Scenario: Adding two numbers together as a union
   Given a context
     And the prefix f as "http://dh.tamu.edu/ns/fabulator/1.0#"
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I run the expression (g:match('^foo', 'fooo'))
   Then I should get 1 item
     And item 0 should be true

  Scenario: Adding two numbers together as a union
   Given a context
     And the prefix f as "http://dh.tamu.edu/ns/fabulator/1.0#"
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I run the expression (g:match('^foo', 'bfooo'))
   Then I should get 1 item
     And item 0 should be false
