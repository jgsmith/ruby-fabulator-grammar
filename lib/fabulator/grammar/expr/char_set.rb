module Fabulator::Grammar::Expr
  class CharSet
    def initialize(cs)
      chars = ""
      ranges = ""
      if cs[0..0] == '-'
        chars = '-'
        cs = cs[1..cs.length-1]
      end
      bits = cs.split(/-/) # to pull out ranges
      if bits.size == 1
        chars = bits[0]
      else
        if bits[0].size > 1
          chars += b[0..0]
        end
        while(bits.size > 1)
          b = bits.shift
          if b.size > 2
            chars += b[1..b.size-2]
          end
          ranges += Regexp.quote(b[b.size-1 .. b.size-1]) + '-' + Regexp.quote(bits[0][0..0])
        end
        if bits[0].size > 1
          chars += bits[0][1..bits[0].size-1]
        end
      end
      chars = chars.collect{ |cc| Regexp.quote(cc) }.join('')
      @set = chars + ranges
      @inverted = false
    end

    def inverted
      @inverted = true
    end

    def to_regex
      if @set != ''
        Regexp.compile("[" + (@inverted ? '^' : '') + @set + "]")
      else
        %r{}
      end
    end
  end
end
