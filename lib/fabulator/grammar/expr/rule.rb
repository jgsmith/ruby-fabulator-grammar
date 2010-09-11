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
              if !ret.nil?
                s.set_result(ret)
                return
              end
            end
          else
            while !s.eof?
              start = s.pos
              @alternatives.each do |alternative|
                ret = s.attempt { |cursor| 
                  cursor.anchored = true 
                  alternative.parse(cursor) 
                }
                if !ret.nil?
                  s.start = start
                  s.set_result(ret)
                  return
                end
              end
              s.advance_position(1)
            end
          end
          raise Fabulator::Grammar::RejectParse
        end
      end
    end
  end
end
