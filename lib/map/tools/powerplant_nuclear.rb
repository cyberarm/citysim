module CitySim
  class Map
    class PowerPlantNuclearTool < Tool
      def places
        :powerplant_nuclear
      end

      def color
        Tool::POWERPLANT_COLOR
      end

      def rows
        4
      end

      def columns
        4
      end
    end
  end
end