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
          ret = false
          case @anchor
            when :start_of_string: 
              ret = source.pos == 0
            when :start_of_line:
            when :end_of_string:
              ret = source.eof?
            when :end_of_line:
          end
          raise Fabulator::Grammar::RejectParse unless ret
        end
      end
    end
  end
end
