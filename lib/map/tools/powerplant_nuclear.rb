module CitySim
  class Map
    class PowerPlantNuclearTool < Tool
      def places
        :powerplant_nuclear
      end

      def color
        Gosu::Color.rgba(255, 255, 25, 150)
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