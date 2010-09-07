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
          ctx = context.with_root(context.root.anon_node(nil))
          ctx.merge_data(data)
          (self.score(ctx).value rescue 0)
        end
      end
    end
  end
end
