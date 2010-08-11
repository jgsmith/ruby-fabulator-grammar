module Fabulator::Grammar::Expr
  class Rules
    def initialize
      @alternatives = [ ]
    end

    def add_alternative(a)
      @alternatives << a
    end

    def to_regex
      Regexp.union(@alternatives.collect{|a| a.to_regex })
    end
  end
end
