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
   When I parse the regex (foo[1,4]$)
   Then it should match "foo"
   Then it should match "fooooo"
   Then it should not match "foooooo"
   Then it should not match "fo"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (^[ [Ff] ]o[ [-a-zA-F01234-9] ]+?)
   Then it should match "foo"
    And it should match "Foo"
    And it should match "FoF03z-"
    And it should not match "hellofoo"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (^[ [Ff] ]o[ [-a-z] + [A-F] + [0-9] - [5] ]+?)
   Then it should match "foo"
    And it should match "Foo"
    And it should match "FoF03z-"
    And it should not match "hellofoo"
    And it should not match "hellof5o"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (^[ [Ff] ]o[ [-] + :lower: + :xdigit: - [5] ]+?)
   Then it should match "foo"
    And it should match "Foo"
    And it should match "FoF03z-"
    And it should not match "hellofoo"
    And it should not match "hellof5o"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (^[ -[0-9] ][ :lower: ][ [0-9] ]$)
   Then it should match "fo0"
    And it should not match "0l0"

  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex (^[-:digit:].[:digit:]$)
   Then it should match "fo0"
    And it should not match "0l0"
    And it should not match "00"

  @chars
  Scenario: Parsing a simple text string
   Given a context
     And the prefix g as "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
   When I parse the regex ([[\[-\]]]o[[a-z\]A-F01234-9]]+?)

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

  @rules
  Scenario: Parsing a simple text string
   Given a context
   Then I can parse the rule (foo bar)
    And I can parse the rule (foo(s) bar(?))
    And I can parse the rule (foo(s?) bar(3))
    And I can parse the rule (foo(s NL) bar(3..4))
    And I can parse the rule (foo ';'(s) bar(3..4 ','))
    And I can parse the rule ((foo bar)(s))
    And I can not parse the rule (foo(s NL(s)))
    And I can parse the rule (foo(s (NL NL(s))))
    And I can not parse the rule (foo(s NL NL(s)))

  @grammar
  Scenario: Parsing a grammar xml definition
    Given a context
    Given the grammar
      """
        <g:grammar xmlns:g="http://dh.tamu.edu/ns/fabulator/grammar/1.0#">
          <g:token g:name="LETTER" g:matches="[:alpha:]" />
          <g:token g:name="NUMBER" g:matches="[:digit:]" />
          <g:rule g:name="something">
            <g:when g:matches="LETTER NUMBER LETTER" />
          </g:rule>
          <g:rule g:name="other">
            <g:when g:matches="a := LETTER b := NUMBER c := LETTER" />
          </g:rule>
          <g:rule g:name="or">
            <g:when g:matches="other(s) d := LETTER(s)" />
          </g:rule>
          <g:rule g:name="ooor">
            <g:when g:matches="other(s ',') d := LETTER(s)" />
          </g:rule>
        </g:grammar>
      """
    Then "something" should match "a0a"
     And "something" should not match "abc"
     And "something" should match "ab0c"
     And "other" should match "a0a" 
     And "other" should match "ab1c" 
     And "or" should match "a1bcde"
     And "or" should match "a1bb2ccde"
     And "or" should match "a1bwb2ccde"
     And "or" should not parse "a1bwb2ccde"
     And "or" should match "acbwb2ccde"
     And "or" should not parse "acbwb2ccde"
     And "or" should not match "acbwb2d"
     And "ooor" should parse "a1c,b2df"
     And the expression (d) should equal ['f']
     And the expression (other[1]/b) should equal ['1']
     And the expression (other[2]/b) should equal ['2']
     And "ooor" should not parse "a1c,b2d"

  @mode
  Scenario: Parsing a grammar xml definition
    Given a context
    Given the grammar
      """
        <g:grammar xmlns:g="http://dh.tamu.edu/ns/fabulator/grammar/1.0#">
          <g:token g:name="LETTER" g:matches="[:alpha:]" g:mode="normal"/>
          <g:token g:name="NUMBER" g:matches="[:digit:]" />
          <g:token g:name="LETTER" g:matches="[:upper:]" g:mode="upper"/>
          <g:token g:name="LETTER" g:matches="[:lower:]" g:mode="lower"/>
          <g:rule g:name="something">
            <g:when g:matches="[mode normal] LETTER NUMBER [mode upper] LETTER" />
          </g:rule>
        </g:grammar>
      """
    Then "something" should parse "a0A"
     And "something" should not parse "a0a"

  @context
  Scenario: Parsing a grammar xml definition
    Given a context
    Given the grammar
      """
        <g:grammar xmlns:g="http://dh.tamu.edu/ns/fabulator/grammar/1.0#">
          <g:context g:mode="normal">
            <g:token g:name="LETTER" g:matches="[:alpha:]" />
          </g:context>
          <g:token g:name="NUMBER" g:matches="[:digit:]" />
          <g:token g:name="LETTER" g:matches="[:upper:]" g:mode="upper"/>
          <g:token g:name="LETTER" g:matches="[:lower:]" g:mode="lower"/>
          <g:rule g:name="something">
            <g:when g:matches="^^ [mode normal] LETTER NUMBER [mode upper] LETTER" />
          </g:rule>
        </g:grammar>
      """
    Then "something" should match "a0A"
     And "something" should not match "a0a"
     And "something" should not match "aa0A"

  @library
  Scenario: Parsing a grammar xml definition
    Given a context
     And the prefix m as "http://example.com/ns/grammar"
     And the prefix f as "http://dh.tamu.edu/ns/fabulator/1.0#"
    Given the library
      """
        <l:library 
                   xmlns:l="http://dh.tamu.edu/ns/fabulator/library/1.0#"
                   xmlns:g="http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
                   xmlns:f="http://dh.tamu.edu/ns/fabulator/1.0#"
                   l:ns="http://example.com/ns/grammar"
        >
          <g:grammar>
            <g:context g:mode="normal">
              <g:token g:name="LETTER" g:matches="[:alpha:]" />
            </g:context>
            <g:token g:name="NUMBER" g:matches="[:digit:]" />
            <g:token g:name="LETTER" g:matches="[:upper:]" g:mode="upper"/>
            <g:token g:name="LETTER" g:matches="[:lower:]" g:mode="lower"/>
            <g:rule g:name="something"> 
              <g:when g:matches="^^ [mode normal] LETTER NUMBER [mode upper] LETTER" />   
            </g:rule>
            <g:rule g:name="something2"> 
              <g:when g:matches="^^ [mode normal] LETTER NUMBER [mode upper] LETTER">
                <g:result g:path="foo" f:select="NUMBER" />
              </g:when>
            </g:rule>
          </g:grammar>
        </l:library>
      """
    Then the expression (m:something?('a0A')) should equal [f:true()]
     And the expression (m:something?('a0a')) should equal [f:false()]
     And the expression (m:something('a0A')/NUMBER) should equal ['0']
     And the expression (m:something2('a0A')/foo) should equal ['0']

