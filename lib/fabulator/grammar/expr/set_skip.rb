module Fabulator
  module Grammar
    module Expr
      class SetSkip
        def initialize(skip)
          @skip = skip
        end

        def parse(cursor)
          cursor.skip = @skip
          {}
        end
      end
    end
  end
end
