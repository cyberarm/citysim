module CitySim
  class Map
    class RoadAndPowerlineTool < Tool
      def places
        :route_road_and_powerline
      end

      def can_use?(x, y)
        true
      end

      def use(x, y, element)
      end

      def type
        :route_road_and_powerline
      end

      def color
        Tool::ROAD_COLOR
      end

      def cost
        Tool::ROAD_COST + Tool::POWERLINE_COST
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