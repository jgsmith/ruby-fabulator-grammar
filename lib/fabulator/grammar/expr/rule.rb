module Fabulator
  module Grammar
    module Expr
      class Rule
        attr_accessor :name

        def initialize
          @alternatives = [ ]
        end

        def add_alternative(a)
          @alternatives << a
        end

        def parse(s)
          if s.anchored
            @alternatives.each do |alternative|
              ret = s.attempt { |cursor| 
                cursor.anchored = true 
                alternative.parse(cursor) 
              }
              return ret unless ret.nil?
            end
          else
            while !s.eof
              @alternatives.each do |alternative|
                ret = s.attempt { |cursor| 
                  cursor.anchored = true 
                  alternative.parse(cursor) 
                }
                return ret unless ret.nil?
              end
              s.advance_position(1)
            end
          end
          return nil
        end
      end
    end
  end
end
