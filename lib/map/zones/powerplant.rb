module CitySim
  class Map
    class PowerPlantZone < Zone
      def setup
        add_tag(:powerplantlike)

        add_tag(:needs_workers)
        add_tag(:produces_power)

        @data[:produce_power_interval] = 500 # ms in game time
        @data[:produce_power_amount] = 10
        @data[:max_power_stored] = 0
      end

      def color
        Tool::POWERPLANT_COLOR
      end

      def label
        "Power Plant"
      end
    end
  end
end