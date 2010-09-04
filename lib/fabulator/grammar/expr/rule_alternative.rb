module Fabulator
  module Grammar
    module Expr
      class RuleAlternative
        def initialize
          @sequences = [ ]
        end

        def add_sequence(s)
          @sequences << s
        end

        def add_directive(m)
          @sequences << m if !m.nil? && m != ''
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
            else
              rr[nom] = r
            end
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
          results
        end
      end
    end
  end
end
