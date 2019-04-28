module CitySim
  class Map
    class PowerPlantCoalTool < Tool
      def places
        :powerplant_coal
      end

      def rows
        3
      end

      def columns
        4
      end
    end
  end
end