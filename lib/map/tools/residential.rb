module CitySim
  class Map
    class ResidentialTool < Tool
      def places
        :zone_residential
      end

      def color
        Gosu::Color.rgba(25, 200, 25, 150)
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