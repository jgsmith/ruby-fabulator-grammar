module Fabulator
  module Grammar
    module Expr
      class RuleMode
        def initialize(m)
          @mode = m
        end

        def parse(s)
          s.mode = @mode
          {}
        end
      end
    end
  end
end
