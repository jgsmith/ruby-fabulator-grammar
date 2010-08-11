module Fabulator::Grammar::Expr
  class Sequence
    def initialize(sub_seq, count = [ :one ])
      @sub_sequence = sub_seq
      @modifiers = ''
      case (count - [:min]).first
        when :zero_or_one: @modifiers = '?'
        when :one_or_more: @modifiers = '+'
        when :zero_or_more: @modifiers = '*'
        when :exact:      
          amt = count.select{ |c| !c.is_a?(Symbol) }
          @modifiers = '{' + amt.first.to_s + '}'
        when :range:
          ends = count.select{ |c| !c.is_a?(Symbol) }
          @modifiers = '{'+ends.join(",")+'}'
      end
      if count.include?(:min) && @modifiers != ''
        @modifiers += "?"
      end
    end

    def to_regex
      s = %r{#{@sub_sequence.to_regex}#{@modifiers}}
    end
  end
end
