module CitySim
  class Map
    class PowerlineTool < Tool
      def places
        :route_powerline
      end

      def color
        Gosu::Color.rgba(255, 255, 25, 150)
      end

      def rows
        1
      end

      def columns
        1
      end
    end
  end
end