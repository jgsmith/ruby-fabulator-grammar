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
          ret = nil
          source.attempt do |c|
            ret = @sequence.parse(c)
            nil
          end
          ret.nil? ? nil : {}
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
          ret = nil
          source.attempt do |c|
            ret = @sequence.parse(c)
            nil
          end
          ret.nil? ? {} : nil
        end
      end

    end
  end
end
