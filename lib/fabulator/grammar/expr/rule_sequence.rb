module Fabulator
  module Grammar
    module Expr
      class RuleSequence

## TODO: allow lookahead here so we can bound the greediness
##       we also need to do non-greedy versions
##       we don't have reasonable backtracking yet

        def initialize(hypo, atom, quant = nil)
          @name = hypo
          @atom = atom
          @quantifier = quant
        end

        # this is the "hypothetical" name in the grammar
        def name
          @name.nil? ? (@atom.name rescue nil) : @name
        end

        def parse(source)
          if @quantifier.nil?
            @atom.parse(source)
          else
            case @quantifier.first
              when '?'.to_sym: 
                r = source.attempt{ |c| @atom.parse(source) }
                source.set_result(r)
              when :s: 
                ret = [ ]
                r = source.attempt { |c| @atom.parse(c) }
                while !r.nil?
                  ret << r
                  if @quantifier[1].nil?
                    r = source.attempt { |c| @atom.parse(c) }
                  else
                    r = source.attempt{ |c| @quantifier[1].parse(c) }
                    if !r.nil?
                      r = source.attempt{ |c| @atom.parse(c) }
                    end
                  end
                end
                raise Fabulator::Grammar::RejectParse if ret.empty?
                source.set_result(ret) 
              when 's?'.to_sym:
                ret = [ ]
                r = source.attempt{ |c| @atom.parse(c) }
                while !r.nil?
                  ret << r
                  if @quantifier[1].nil?
                    r = source.attempt{ |c| @atom.parse(c) }
                  else
                    r = source.attempt{ |c| @quantifier[1].parse(c) }
                    if !r.nil?
                      r = source.attempt{ |c| @atom.parse(c) }
                    end
                  end
                end
                source.set_result(ret) unless ret.empty?
            end
          end
          source.name_result(@atom.name)
        end
      end
    end
  end
end

