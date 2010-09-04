module Fabulator
  module Grammar
    module Expr
      class RuleSequence
        def initialize(hypo, atom, quant = nil)
          @name = hypo
          @atom = atom
          @quantifier = quant
        end

        # eventually, this can be the hypo name
        def name
          @name.nil? ? (@atom.name rescue nil) : @name
        end

        def parse(source)
          if @quantifier.nil?
            return @atom.parse(source)
          end

          case @quantifier.first
            when '?': return @atom.parse(source) || { }
            when 's': 
              ret = [ ]
              r = @atom.parse(source)
              while !r.nil?
                ret << r
                if @quantifier[1].nil?
                  r = @atom.parse(source)
                else
                  r = @quantifier[1].parse(source)
                  if !r.nil?
                    r = @atom.parse(source)
                  end
                end
              end
              return ret.empty? ? nil : ret
            when 's?':
              ret = [ ]
              r = @atom.parse(source)
              while !r.nil?
                ret << r
                if @quantifier[1].nil?
                  r = @atom.parse(source)
                else
                  r = @quantifier[1].parse(source)
                  if !r.nil?
                    r = @atom.parse(source)
                  end
                end
              end
              return ret.empty? ? {} : ret
          end
        end
      end
    end
  end
end

