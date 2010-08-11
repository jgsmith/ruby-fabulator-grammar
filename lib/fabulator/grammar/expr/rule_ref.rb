module Fabulator::Grammar::Expr
  class RuleRef
    def initialize(qname)
      bits = qname.split(/:/,2)
      @ns_prefix = bits[0]
      @name = bits[1]
    end

    def to_regex
      %r{}
    end
  end
end
