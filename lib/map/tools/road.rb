module CitySim
  class Map
    class RoadTool < Tool
      def places
        :route_road
      end

      def type
        :route
      end

      def color
        Tool::ROAD_COLOR
      end

      def cost
        Tool::ROAD_COST
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