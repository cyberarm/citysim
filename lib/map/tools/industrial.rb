module CitySim
  class Map
    class IndustrialTool < Tool
      def places
        :zone_industrial
      end

      def color
        Gosu::Color.rgba(255, 25, 25, 150)
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