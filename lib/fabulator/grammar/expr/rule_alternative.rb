module Fabulator
  module Grammar
    module Expr
      class RuleAlternative
        def initialize
          @sequences = [ ]
        end

        def add_sequence(s)
          s = [ s ] unless s.is_a?(Array)
          @sequences += s
        end

        def parse(source)
          results = [ ]
          @sequences.each do |sequence|
            res = source.attempt{ |s| sequence.parse(s) }
            raise Fabulator::Grammar::RejectParse if res.nil?
            res.children.each do |c|
              if c.name.nil?
                c.name = sequence.name if c.name.nil? && !sequence.name.nil?
                res.prune(c)
                results << c if !c.children.empty? || !c.value.nil?
              end
            end
            res.name = sequence.name unless sequence.name.nil?
            results << res if !res.children.empty? || !res.value.nil?
          end
          # now we want to merge all of the results
          if results.size > 1
            results = results.select{ |r| !r.name.nil? }
          end
          if !results.empty?
            source.set_result(results)
          end
        end
      end
    end
  end
end
