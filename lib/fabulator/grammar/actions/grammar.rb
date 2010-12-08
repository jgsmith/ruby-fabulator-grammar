module Fabulator
  module Grammar
    module Actions
      class Grammar < Fabulator::Structural

    namespace GRAMMAR_NS

    element :grammar

    contains :rule
    contains :token
    contains :context

    contained_in Fabulator::FAB_LIB_NS, :library

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
      cursor.eof? ? ret : nil
    end

    def match(ctx, nom, s)
      cursor = Fabulator::Grammar::Cursor.new(self, ctx, s)
      !do_parse(nom, cursor).nil?
    end

    def run_function(context, nom, args)
      # treat these as mappings
      strings = args.collect{ |a| a.to_s }
      matching = false
      if nom =~ /\?$/
        matching = true
      end
      nom.gsub!(/\?$/, '')
      ret = matching ? strings.collect{ |s| self.match(context, nom, s) } :
                       strings.collect{ |s| self.parse(context, nom, s) }
      ret -= [ nil ]
      if matching
        ret = ret.collect{ |r| context.root.anon_node(!!r, [FAB_NS, 'boolean']) }
      else
        while ret.select{ |r| r.name.nil? && r.value.nil? }.size > 0
          ret = ret.collect{ |r|
            if r.name.nil? && r.value.nil?
              r.children
            else
              r
            end
          }.flatten - [ nil ]
        end
        if !ret.empty?
          new_ret = ret.first.roots['data'].anon_node(nil)
          ret.each do |r|
            new_ret.add_child(r)
          end
        end
        ret = [ new_ret ]
      end
      ret
    end

    def run_filter(ctx, nom)
      # runs as a parser and replaces the string with the resulting
      # content that matched
      source = ctx.root.to_s
      cursor = Fabulator::Grammar::Cursor.new(self, ctx, source)
      ret = do_parse(nom, cursor)
      ctx.root.value = ret.nil? ? '' : source[cursor.start .. cursor.pos-1]
    end

    def run_constraint(ctx, nom)
      # runs as a match and requires full anchored matching
      !self.parse(ctx, nom, ctx.root.to_s).nil?
    end

      protected

    def do_parse(nom, cursor)
      obj = get_rule(:default, nom)
      return nil if obj.nil?

      begin
        obj.parse(cursor)
      rescue Fabulator::Grammar::RejectParse
        return nil
      else
        return cursor.context.root
      end
    end

      end
    end
  end
end
