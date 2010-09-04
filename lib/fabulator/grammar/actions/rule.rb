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

        def compile_xml(xml, ctx)
          super

          self
        end

        def mode
          @mode.to_sym
        end

        def name
          @name
        end

        def parse(cursor)
          # try each when...
          @choices.each do |choice|
            cursor.attempt do |c|
              ret = choice.parse(c)
              if !ret.nil?
                if choice.has_actions?
                  ctx = cursor.context.with_root(cursor.context.root.anon_node(nil))
                  ctx.merge_data(ret)
                  choice.run(ctx)
                end
                return ret
              end
            end
          end
          return nil
        end
      end
    end
  end
end
