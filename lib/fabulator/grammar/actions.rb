#require 'fabulator/grammar/actions/grammar'

module Fabulator
  GRAMMAR_NS = "http://dh.tamu.edu/ns/fabulator/grammar/1.0#"
  module Grammar
    module Actions
      class Lib
        include Fabulator::ActionLib

        register_namespace GRAMMAR_NS

        #action 'grammar', Grammar

        ## reference a grammar name
        function 'match' do |ctx, args|
          # first arg is the regex or <rule name>
          regex = args[0].to_s
          parser = Fabulator::Grammar::Parser.new
          compiled = parser.parse(regex, ctx).to_regex
          if args[1].is_a?(Array)
            args[1].collect{|a|
              if a.to_s =~ compiled
                ctx.root.anon_node(true)
              else
                ctx.root.anon_node(false)
              end
            }
          elsif args[1].to_s =~ compiled
            [ ctx.root.anon_node(true) ]
          else
            [ ctx.root.anon_node(false) ]
          end
        end

        function 'tokenize' do |ctx, args|
        end
      end
    end
  end
end

# modifiers: g:minimal, g:ignore-case, g:space, g:ratchet

# need the concept of hypotheticals here

# <g:grammar g:namespace=''>
#   <g:token|g:regex g:name=''>
#     <g:literal />
#     <g:capture>...</g:capture>
#     <g:group>...</g:group>
#     <g:before>...</g:before>
#     <g:after>...</g:after>
#     <g:not-before>...</g:not-before>
#     <g:not-after>...</g:not-after>
#     <g:alternatives>...</g:alternatives>
#     <g:token />
#     <g:one-or-more>...</g:one-or-more>
#     <g:zero-or-more>...</g:zero-or-more>
#     <g:zero-or-one>...</g:zero-or-one>
#     <g:many g:min='' g:max=''>...</g:many>
#   </g:token>
#   <g:rule g:name=''>
#     <g:when><g:pattern>...</g:pattern>...</g:when>
#   </g:rule>
# </g:grammar>
