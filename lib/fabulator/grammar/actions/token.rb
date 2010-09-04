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
          @c_matches = parser.parse(@matches)
          self
        end


        def mode
          @mode.to_sym
        end

        def name
          @name
        end

        def parse(cursor)
          @c_matches.parse(cursor)
        end
      end
    end
  end
end
