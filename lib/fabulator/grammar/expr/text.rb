module Fabulator::Grammar::Expr
  class Text
    def initialize(t)
      @text = t
    end

    def to_regex
      Regexp.escape(@text)
    end
  end
end
