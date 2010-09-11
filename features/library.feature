@library
Feature: Grammars embedded in libraries

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

  @library
  Scenario: Using a grammar for filters and constraints
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
              <g:when g:matches="[mode normal] LETTER NUMBER [mode upper] LETTER" />
            </g:rule>
            <g:rule g:name="something2">
              <g:when g:matches="[mode normal] LETTER NUMBER [mode upper] LETTER">
                <g:result g:path="foo" f:select="NUMBER" />
              </g:when>
            </g:rule>
          </g:grammar>
          <l:mapping l:name="double">
            <f:value-of f:select=". * 2" />
          </l:mapping>
          <l:function l:name="fctn">
            <f:value-of f:select="$1 - $2" />
          </l:function>
          <l:action l:name="actn" l:has-actions="true">
            <f:value-of f:select="f:eval($actions) * 3" />
          </l:action>
        </l:library>
      """
     And the statemachine
      """
        <f:application xmlns:f="http://dh.tamu.edu/ns/fabulator/1.0#"
                       xmlns:m="http://example.com/ns/grammar"
        >
          <f:view f:name="start">
            <f:goes-to f:view="step1">
              <f:params>
                <f:param f:name="foo">
                  <f:filter f:name="m:something" />
                  <f:value>a0A</f:value>
                </f:param>
              </f:params>
              <f:value f:path="barbell" f:select="m:double(3)" />
              <f:value f:path="barboil">
                <m:actn><f:value-of f:select="7" /></m:actn>
              </f:value>
            </f:goes-to>
          </f:view>
          <f:view f:name="step1">
            <f:goes-to f:view="stop">
              <f:params>
                <f:param f:name="bar">
                  <f:filter f:name="trim" />
                  <f:constraint f:name="m:something" />
                </f:param>
              </f:params>
            </f:goes-to>
          </f:view>
          <f:view f:name="stop" />
        </f:application>
      """
    Then it should be in the 'start' state  
    When I run it with the following params:
      | key   | value         |
      | foo   | bar  a0a  que   |
    Then it should be in the 'start' state
     And the expression (/foo) should be nil
    When I run it with the following params:
      | key   | value |   
      | foo   | bara0Aque   |
    Then it should be in the 'step1' state
     And the expression (/foo) should equal ['a0A']
     And the expression (/barbell) should equal [6]
     And the expression (/barboil) should equal [21]
    When I run it with the following params:
      | key   | value |   
      | bar   | a0a   |
    Then it should be in the 'step1' state
    When I run it with the following params:
      | key   | value |   
      | bar   | a0B   |
    Then it should be in the 'stop' state
     And the expression (/bar) should equal ['a0B']
     And the expression (m:fctn(3,2)) should equal [1]
