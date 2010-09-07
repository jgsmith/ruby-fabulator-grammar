module Fabulator
  module Grammar
    module Actions
      class Rule < Fabulator::Structural

        namespace GRAMMAR_NS

        attribute :name, :static => true
        attribute :mode, :default => "default", :static => true

        contains :when, :as => :choices

        has_actions

        def initialize(g = nil)
          @grammar = g
          @choices = [ ]
        end

        def parse(cursor)
          # try each when...
          best_attempt = nil
          @choices.each do |choice|
            cursor.attempt do |c|
              ret = choice.parse(c)
              if !ret.nil?
                score = choice.score(cursor.context, ret)
                if best_attempt.nil? || best_attempt[:score] < score
                  best_attempt = {
                    :score => score,
                    :choice => choice,
                    :ret => ret
                  }
                end
              end
            end
          end
          return nil if best_attempt.nil?
          choice = best_attempt[:choice]
          ret = best_attempt[:ret]
          if choice.has_actions?
            ctx = cursor.context.with_root(cursor.context.root.anon_node(nil))
            ctx.merge_data(ret)
            choice.run(ctx)
          end
          return ret
        end
      end
    end
  end
end
