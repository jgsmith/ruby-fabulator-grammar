module Fabulator::Grammar::Expr
  class RuleRef
    def initialize(qname)
      bits = qname.split(/:/,2)
      if bits.size > 1
        @ns_prefix = bits[0]
        @name = bits[1]
      else
        @name = qname
      end
    end

    def name
      @name
    end

    def parse(cursor)
      rule = cursor.find_rule(@name)
      return nil if rule.nil?
      # we have @name as the path prefix for this part?
      cursor.attempt { |c| rule.parse(c) }
    end
  end
end
