module CitySim
  class Map
    class CityParkTool < Tool
      def places
        :service_city_park
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