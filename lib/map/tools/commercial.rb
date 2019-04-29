module CitySim
  class Map
    class CommericalTool < Tool
      def places
        :zone_commercial
      end

      def color
        Tool::COMMERCIAL_COLOR
      end

      def cost
        Tool::COMMERCIAL_COST
      end

      def rows
        3
      end

      def columns
        3
      end
    end
  end
end