module Fabulator
  module Grammar
    module Actions
      class Token < Fabulator::Structural

        namespace GRAMMAR_NS

        attribute :name, :static => true
        attribute :mode, :default => "default", :static => true
        attribute :matches, :static => true

        def compile_xml(xml, ctx = nil)
          super

          parser = Fabulator::Grammar::TokenParser.new

          # parse @matches
          @c_matches = parser.parse(self.matches)
        end

        def parse(cursor)
          @c_matches.parse(cursor)
        end
      end
    end
  end
end
