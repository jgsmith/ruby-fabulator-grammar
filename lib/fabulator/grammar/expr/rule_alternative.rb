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
          results = { }
          @sequences.each do |sequence|
            r = sequence.parse(source)
            return nil if r.nil? # we fail
            nom = (sequence.name rescue nil)
            rr = { }
            if nom.nil?
              rr = r
            elsif !r.nil?
              if !(r.is_a?(Hash) || r.is_a?(Array)) || !r.empty?
                rr[nom] = r
              end
            end
            if rr.is_a?(Hash) && !rr.empty?
              rr.each_pair do |k,v|
                if results[k].nil?
                  results[k] = v
                elsif results[k].is_a?(Array)
                  results[k] << v
                else
                  results[k] = [ results[k], v ]
                end
              end
            end
          end
          results
        end
      end
    end
  end
end
