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
            ret = cursor.attempt { |c| choice.parse(c) }
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
          raise Fabulator::Grammar::RejectParse if best_attempt.nil?
          choice = best_attempt[:choice]
          ret = best_attempt[:ret]
          if choice.has_actions?
            cursor.context.root.roots['result'] = cursor.context.root.roots['result'].anon_node(nil)
            new_ret = cursor.context.root.roots['result']
            choice.run(cursor.context.with_root(ret))
            cursor.set_result(new_ret)
          else
            cursor.set_result(ret)
          end
        end
      end
    end
  end
end
