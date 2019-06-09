module CitySim
  class Map
    class PowerPlantZone < Zone
      def setup
        add_tag(:powerplantlike)

        @needs = Data.new(0, 0, 5)
        add_tag(:needs_workers)
        add_tag(:produces_power)

        @map.every(self, 1000) do
          route = nearest_route(:powerlinelike)
          create_agent(PowerAgent, route, nil) if route
        end
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