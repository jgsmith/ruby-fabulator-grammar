module Fabulator::Grammar::Expr
  class TokenAlternative
    def initialize
      @sequences = [ ]
      @anchor_start = false
      @anchor_end = false
    end

    def anchor_start(t)
      @anchor_start = case t
        when '^': '^'
        when '^^': '\A'
      end
    end

    def anchor_end(t)
      @anchor_end = case t
        when '$': '$'
        when '$$': '\Z'
      end
    end

    def add_sequence(s)
      @sequences << s
    end

    def to_regex
      r = %r{#{@sequences.collect{ |s| s.to_regex }}}
      if @anchor_start
        if @anchor_end
          %r{#{@anchor_start}#{r}#{@anchor_end}}
        else
          %r{#{@anchor_start}#{r}}
        end
      elsif @anchor_end
        %r{#{r}#{@anchor_end}}
      else
        r
      end
    end
  end
end
