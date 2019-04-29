module CitySim
  class Map
    class IndustrialTool < Tool
      def places
        :zone_industrial
      end

      def color
        Tool::INDUSTRIAL_COLOR
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