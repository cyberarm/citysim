module CitySim
  class Map
    class PowerPlantZone < Zone
      def setup
        @map.every(1000) do
          route = nearest_route(PowerLineRoute)
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