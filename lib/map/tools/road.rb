module CitySim
  class Map
    class RoadTool < Tool
      def places
        :route_road
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