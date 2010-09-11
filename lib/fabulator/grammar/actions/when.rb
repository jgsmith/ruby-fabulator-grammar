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
          @c_matches = parser.parse(self.matches)
        end

        def parse(cursor)
          @c_matches.parse(cursor)
        end

        def score(context, data)
          return 0 if @score.nil?
          (@score.run(context.with_root(context.root.roots['result'])).value rescue 0)
        end
      end
    end
  end
end
