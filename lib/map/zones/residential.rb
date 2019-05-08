module CitySim
  class Map
    attr_reader :residents
    class ResidentialZone < Zone
      def setup
        @residents = 0
        @map.every(self, 10_000) do
          if route = nearest_route(RoadRoute)
            choice = @map.elements.select {|e| e if e.is_a?(CommercialZone)}.shuffle.detect {|c| c.nearest_route(RoadRoute) != nil}
            if choice
              create_agent(VehicleAgent, route, choice.nearest_route(RoadRoute))
            end
          end
        end
      end

      def color
        Tool::RESIDENTIAL_COLOR
      end

      def label
        "Residential"
      end
    end
  end
end