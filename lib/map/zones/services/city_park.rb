module CitySim
  class Map
    class CityParkZone < Zone
      def color
        Tool::CITY_PARK_COLOR
      end

      def label
        "City Park"
      end
    end
  end
end