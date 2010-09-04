module Fabulator
  module Grammar
    module Actions
      class When < Fabulator::Structural

        namespace GRAMMAR_NS

        attribute :matches, :static => true
        attribute :score, :eval => true

        has_actions

        def compile_xml(xml, ctx = nil)
          super

          parser = Fabulator::Grammar::RuleParser.new
          # parse @matches
          @c_matches = parser.parse(@matches)
          self
        end

        def parse(cursor)
          @c_matches.parse(cursor)
        end

        def run(context)
          @actions.run(context)
        end
      end
    end
  end
end
