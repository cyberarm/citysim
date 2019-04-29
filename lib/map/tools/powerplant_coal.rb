module CitySim
  class Map
    class PowerPlantCoalTool < Tool
      def places
        :powerplant_coal
      end

      def color
        Gosu::Color.rgba(255, 255, 25, 150)
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