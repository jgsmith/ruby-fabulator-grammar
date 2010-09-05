module Fabulator
  module Grammar
    module Expr
      class Anchor
        def initialize(t)
          @anchor = t
        end

        def name
          nil
        end

        def parse(source)
          ret = nil
          case @anchor
            when :start_of_string: 
              ret = source.pos == 0 ? {} : nil
            when :start_of_line:
            when :end_of_string:
              ret = source.eof ? {} : nil
            when :end_of_line:
          end
          ret
        end
      end
    end
  end
end
