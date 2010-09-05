module Fabulator
  module Grammar
    module Actions
      class Grammar < Fabulator::Structural

    namespace GRAMMAR_NS

    contains :rule
    contains :token
    contains :context

    has_actions

    def compile_xml(xml, context = nil)
       super

      @modes = { :default => { } }

      @contexts.each do |c|
        c.tokens.each do |token|
          self.add_rule(token, c.mode)
        end
        c.rules.each do |rule|
          self.add_rule(rule, c.mode)
        end
      end
      @tokens.each do |token|
        self.add_rule(token)
      end
      @rules.each do |rule|
        self.add_rule(rule)
      end

      @tokens = nil
      @rules = nil

      self
    end

    def add_rule(r, m = :default)
      return if r.nil?
      mode = ((r.mode.nil? || r.mode.to_sym == :default) ? m : r.mode).to_sym
      @modes[mode] ||= { }
      @modes[mode][r.name.to_sym] = r
    end

    def get_rule(m, nom)
      @modes[m.to_sym].nil? ? nil : @modes[m.to_sym][nom.to_sym]
    end

    def parse(ctx, nom, s)
      cursor = Fabulator::Grammar::Cursor.new(self, ctx, s)
      cursor.anchored = true
      ret = do_parse(nom, cursor)
      cursor.do_skip
      cursor.eof ? ret : nil
    end

    def match(ctx, nom, s)
      cursor = Fabulator::Grammar::Cursor.new(self, ctx, s)
      !do_parse(nom, cursor).nil?
    end

      protected

    def do_parse(nom, cursor)
      obj = get_rule(:default, nom)
      return nil if obj.nil?

      obj.parse(cursor)
    end

      end
    end
  end
end
