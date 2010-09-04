require 'bitset'

module Fabulator::Grammar::Expr
  class CharSet
    def initialize(cs = "")
      @set = BitSet.new
      if cs[0..0] == '-'
        @set.on(('-')[0])
        cs = cs[1..cs.length-1]
      end
      bits = cs.split(/-/) # to pull out ranges
      if bits.size == 1
        bits[0].each_char{ |c|
          @set.on(c[0])
        }
      elsif bits.size > 1
        if bits[0].size > 1
          @set.on(bits[0][0])
        end
        while(bits.size > 1)
          b = bits.shift
          if b.size > 2
            b[1..b.size-2].each_char { |c| @set.on(c[0]) }
          end
          @set.on(b[b.size-1] .. bits[0][0])
        end
        if bits[0].size > 1
          bits[0][1..bits[0].size-2].each_char { |c|
            @set.on(c[0])
          }
        end
      end
    end

    def set
      @set
    end

    def or(c)
      @set = @set | c.set
      self
    end

    def but_not(c)
      @set = @set - c.set
      self
    end

# for now, we restrict ourselves to 8-bit characters
    def universal
      @set.on(0..0xff)
    end

    def to_regex
      # want a compact set of ranges for the regex
      set_def = ''
      @set.to_ary.each do |r|
        if r.is_a?(Range)
          set_def += Regexp.quote(r.begin.to_i.chr) + '-' + Regexp.quote(r.end.to_i.chr)
        else
          set_def += Regexp.quote(r.to_i.chr)
        end
      end
      if set_def == ''
        return %r{.}
      else
        %r{[#{set_def}]}
      end
    end
  end

  class CharClass < CharSet
    @@charsets = {
      'alnum' => [ 0x30 .. 0x39, 0x41 .. 0x5a, 0x61 .. 0x7a ],
      'alpha' => [ 0x41 .. 0x5a, 0x61 .. 0x7a ],
      'ascii' => [ 0x00 .. 0x7f ],
      'blank' => [ 0x0b, 0x20 ], # \t + space
      'cntrl' => [ 0x00 .. 0x1f, 0x7f ],
      'digit' => [ 0x30 .. 0x39 ],
      'graph' => [ 0x21 .. 0x7e ],
      'lower' => [ 0x61 .. 0x7a ],
      'print' => [ 0x20 .. 0x7e ],
      'space' => [ 0x0a, 0x0b, 0x0c, 0x0f, 0x20 ], # \t\r\n\v\f + space
      'upper' => [ 0x41 .. 0x5a ],
      'word'  => [ 0x30 .. 0x39, 0x41 .. 0x5a, 0x61 .. 0x7a, '_'[0] ],
      'xdigit'=> [ 0x30 .. 0x39, 0x41 .. 0x46, 0x61 .. 0x66 ]
    }

    def initialize(cs)
      @set = BitSet.new.on(@@charsets[cs.downcase] || [])
    end
  end
end
