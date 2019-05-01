module CitySim
  class Map
    class PowerPlantZone < Zone
      def color
        Tool::POWERPLANT_COLOR
      end

      def label
        "Power Plant"
      end
    end
  end
end