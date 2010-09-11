module Fabulator
  module Grammar
  module Actions
  class Result < Fabulator::Action
    attr_accessor :select, :name

    namespace Fabulator::GRAMMAR_NS
    attribute :path, :static => true
    has_select
    has_actions

    def run(context, autovivify = false)
      @context.with(context) do |ctx|
        values = self.has_actions? ? self.run_actions(ctx) : @select.run(ctx,false)
        if !values.nil?
          ctx.with_root(ctx.root.roots['result']).set_value(self.path, values)
        end
      end
    end
  end
  end
  end
end
