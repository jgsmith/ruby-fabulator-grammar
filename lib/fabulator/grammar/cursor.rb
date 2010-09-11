module Fabulator
  module Grammar
    class Cursor
      attr_accessor :mode, :skip, :start

      def initialize(g,ctx,s)
        @source = s
        @grammar = g
        @start = 0
        @curpos = 0
        @end = @source.length-1
        @line = 0
        @col = 0
        @anchored = false
        @mode = :default
        @skip = nil
        @context = ctx.with_root(ctx.root.anon_node(nil))
        @context.root.roots['result'] = @context.root
        @context.root.axis = 'result'
      end

      def context
        @context
      end

      def pos
        @curpos
      end

      def resync(pat)
        until self.eof || @source[@curpos..@source.length-1] =~ %r{^#{pat}}
          @curpos += 1
        end
      end

      def eof?
        @curpos > @end
      end

      def advance_position(i)
        @curpos += i if i > 0
      end

      def anchored
        @anchored
      end

      def anchored=(t)
        @anchored = t
      end

      def grammar
        @grammar
      end

      def point
        r = { :curpos => @curpos, :line => @line, :col => @col, :root => @context.root, :mode => @mode, :anchored => @anchored, :skip => @skip, :result => @context.root.roots['result'] }
        @context.root.roots['result'] = r[:result].anon_node(nil)
        @context.root = @context.root.roots['result']
        r
      end

      def point=(p)
        @curpos = p[:curpos]
        @line = p[:line]
        @col = p[:col]
        @mode = p[:mode]
        @anchored = p[:anchored]
        @skip = p[:skip]
        @context.root = p[:root]
        @context.root.roots['result'] = p[:result]
      end

      def attempt(&block)
        saved = self.point
        begin
          yield self
        rescue Fabulator::Grammar::RejectParse
          self.point = saved
          return nil
        end

        ret = @context.root.roots['result']
        @context.root = saved[:root]
        @context.root.roots['result'] = saved[:result]
        return ret
      end

      def set_result(r)
        r = [ r ] unless r.is_a?(Array)
        if r.size > 1
          @context.root = @context.root.anon_node(nil)
          r.each { |rr| @context.root.add_child(rr) }
        elsif !r.empty?
          @context.root = r.first
        end
        @context.root.roots['result'] = @context.root
      end

      def name_result(nom = nil)
        return if nom.nil?
        return if @context.root.value.nil? && @context.root.children.empty?
        if @context.root.value.nil?
          @context.root.name = nom
        else
          if @context.root.name.nil?
            @context.root.name = nom
          else
            n = @context.root.anon_node(nil)
            n.name = nom
            n.add_child(@context.root)
            @context.root = n
            @context.root.roots['result'] = @context.root
          end
        end
      end

      def rename_result(nom = nil)
        return if nom.nil?
        return if @context.root.value.nil? && @context.root.children.empty?
#        if @context.root.children.select{ |c| !c.name.nil? }.empty?
#          @context.root.children.each { |c| c.name = nom }
#        else
          @context.root.name = nom
#        end
      end

      def find_rule(nom)
        r = @grammar.get_rule(@mode, nom)
        if r.nil? && @mode.to_s != 'default'
          r = @grammar.get_rule('default', nom)
        end
        r
      end

      def data
        @context
      end

      def do_skip
        if !@skip.nil?
          my_skip = @skip
          new_pos = @curpos
          self.attempt do |cursor|
            cursor.skip = nil
            cursor.anchored
            r = my_skip.parse(cursor)
            while !r.nil?
              r = my_skip.parse(cursor)
            end
            new_pos = cursor.pos
          end
          @curpos = new_pos
        end
      end

      def match_token(regex)
        do_skip
        if @source[@curpos .. @end] =~ %r{^(#{regex})}
          @context.root.value = $1.to_s
          @curpos += @context.root.value.length
        else
          raise Fabulator::Grammar::RejectParse
        end
      end
    end
  end
end
