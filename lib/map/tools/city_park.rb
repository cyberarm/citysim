module CitySim
  class Map
    class CityParkTool < Tool
      def places
        :service_city_park
      end

      def color
        Tool::CITY_PARK_COLOR
      end

      def cost
        Tool::CITY_PARK_COST
      end

      def rows
        2
      end

      def columns
        2
      end
    end
  end
end