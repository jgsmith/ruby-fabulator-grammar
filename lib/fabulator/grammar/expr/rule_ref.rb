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
      raise Fabulator::Grammar::RejectParse if rule.nil?
      # we have @name as the path prefix for this part?
      ret = cursor.attempt { |c| rule.parse(c) }

      raise Fabulator::Grammar::RejectParse if ret.nil?

      cursor.set_result(ret)
    end
  end
end
