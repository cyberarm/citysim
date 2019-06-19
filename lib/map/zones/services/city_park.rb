module CitySim
  class Map
    class CityParkZone < Zone
      def setup
        add_tag(:needs_power)

        @data[:max_power] = 2
      end

      def color
        Tool::CITY_PARK_COLOR
      end

      def label
        "City Park"
      end
    end
  end
end