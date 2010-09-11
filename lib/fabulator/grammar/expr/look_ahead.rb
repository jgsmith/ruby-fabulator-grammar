module Fabulator
  module Grammar
    module Expr
      class LookAhead
        def initialize(sequence)
          @sequence = sequence
        end

        def name
          nil
        end

        def parse(source)
          ret = false
          source.attempt do |c|
            ret = @sequence.parse(c)
            raise Fabulator::Grammar::RejectParse
          end
          raise Fabulator::Grammar::RejectParse unless ret
        end
      end

      class NegLookAhead   
        def initialize(sequence)
          @sequence = sequence
        end
 
        def name
          nil  
        end
 
        def parse(source)
          ret = false
          source.attempt do |c|
            ret = @sequence.parse(c)
            raise Fabulator::Grammar::RejectParse
          end
          raise Fabulator::Grammar::RejectParse if ret
        end
      end

    end
  end
end
