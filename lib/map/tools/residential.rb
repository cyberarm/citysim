module CitySim
  class Map
    class ResidentialTool < Tool
      def places
        :zone_residential
      end

      def color
        Tool::RESIDENTIAL_COLOR
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