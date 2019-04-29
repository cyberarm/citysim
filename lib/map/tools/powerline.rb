module CitySim
  class Map
    class PowerlineTool < Tool
      def places
        :route_powerline
      end

      def type
        :route
      end

      def color
        Tool::POWERLINE_COLOR
      end

      def cost
        Tool::POWERLINE_COST
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