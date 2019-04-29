module CitySim
  class Map
    class PowerPlantSolarTool < Tool
      def places
        :powerplant_solar
      end

      def color
        Gosu::Color.rgba(255, 255, 25, 150)
      end

      def rows
        8
      end

      def columns
        4
      end
    end
  end
end