module Fabulator::Grammar::Expr
  class Token
    attr_accessor :name

    def initialize
      @alternatives = [ ]
    end

    def add_alternative(a)
      @alternatives << a
    end

    def to_regex
      Regexp.union(@alternatives.collect{|a| a.to_regex })
    end

    def parse(cursor)
      res = cursor.match_token(self.to_regex)
      if res.nil?
        return nil
      else
        return res
      end
    end
  end
end
