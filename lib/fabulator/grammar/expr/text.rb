module Fabulator::Grammar::Expr
  class Text
    def initialize(t)
      @text = t
    end

    def to_regex
      Regexp.escape(@text)
    end

    def name
      nil
    end

    def parse(cursor)
      cursor.match_token(Regexp.quote(@text))
    end
  end
end
