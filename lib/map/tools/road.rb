module CitySim
  class Map
    class RoadTool < Tool
      def places
        :route_road
      end

      def color
        Gosu::Color.rgba(0, 0, 0, 150)
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