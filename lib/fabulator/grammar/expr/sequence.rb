module Fabulator::Grammar::Expr
  class Sequence
    def initialize(sub_seq, count = [ :one ])
      @sub_sequence = sub_seq
      @count = count
    end

    def to_regex
      s = @sub_sequence.to_regex
      
    end
  end
end
