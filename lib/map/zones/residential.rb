module CitySim
  class Map
    class ResidentialZone < Zone
      def setup
        add_tag(:receives_residents)

        @map.every(self, 10_000) do
          if route = nearest_route(:roadlike)
            choice = @map.elements.select {|e| e if e.is_a?(CommercialZone)}.shuffle.detect {|c| c.nearest_route(:roadlike) != nil}
            if choice
              create_agent(VehicleAgent, route, choice.nearest_route(:roadlike))
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