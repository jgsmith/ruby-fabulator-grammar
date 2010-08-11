module Fabulator::Grammar::Expr
  class Rule
    def initialize
      @sequences = [ ]
      @anchor_start = false
      @anchor_end = false
    end

    def anchor_start
      @anchor_start = true
    end

    def anchor_end
      @anchor_end = true
    end

    def add_sequence(s)
      @sequences << s
    end

    def to_regex
      r = %r{#{@sequences.collect{ |s| s.to_regex }}}
      if @anchor_start
        if @anchor_end
          %r{^#{r}$}
        else
          %r{^#{r}}
        end
      elsif @anchor_end
        %r{#{r}$}
      else
        r
      end
    end
  end
end
