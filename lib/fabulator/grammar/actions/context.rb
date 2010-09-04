module Fabulator
  module Grammar
    module Actions
      class Context < Fabulator::Structural

    namespace GRAMMAR_NS

    attribute :mode, :default => :default, :static => true

    attr_accessor :mode, :tokens, :rules

    contains :rule
    contains :token

      end
    end
  end
end
