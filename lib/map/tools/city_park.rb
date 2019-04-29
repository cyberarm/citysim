module CitySim
  class Map
    class CityParkTool < Tool
      def places
        :service_city_park
      end

      def color
        Gosu::Color.rgba(255, 127, 25, 150)
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