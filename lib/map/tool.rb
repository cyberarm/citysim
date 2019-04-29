module CitySim
  class Map
    class Tool
      def self.tools
        unless @tools
          @tools = {}

          @list.each do |subclass|
            instance = subclass.new
            raise "Tool #{instance.places.inspect} already defined!" if @tools[instance.places]
            @tools[instance.places] = instance
          end
        end

        @tools
      end

      def self.inherited(subclass)
        @list ||= []
        @list << subclass
      end

      def places
        nil
      end

      def demolishes?
        false
      end

      def color
        Gosu::Color.rgba(100, 100, 150, 100)
      end

      def rows
        raise "#{self.class}#rows not overridden!"
      end

      def columns
        raise "#{self.class}#columns not overridden!"
      end
    end
  end
end