module Fabulator
  module Grammar
    class Cursor
      attr_accessor :mode, :skip

      def initialize(g,ctx,s)
        @source = s
        @grammar = g
        @curpos = 0
        @end = @source.length-1
        @line = 0
        @col = 0
        @anchored = false
        @mode = :default
        @skip = nil
        @context = ctx.with_root(ctx.root.anon_node(nil))
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

      def eof
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
        { :curpos => @curpos, :line => @line, :col => @col, :root => @context.root, :mode => @mode, :anchored => @anchored, :skip => @skip }
      end

      def point=(p)
        @curpos = p[:curpos]
        @line = p[:line]
        @col = p[:col]
        @mode = p[:mode]
        @anchored = p[:anchored]
        @skip = p[:skip]
        @context.root = p[:root]
      end

      def attempt(&block)
        saved = self.point
        ret = yield self
        if ret.nil?
          self.point = saved
          return nil
        end
        
        return ret
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
        res = nil
        do_skip
        if @source[@curpos .. @end] =~ %r{^(#{regex})}
          res = $1.to_s
          @curpos += res.length
        end
        res
      end
    end
  end
end
