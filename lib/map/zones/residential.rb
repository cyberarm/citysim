module CitySim
  class Map
    attr_reader :residents
    class ResidentialZone < Zone
      def setup
        @residents = 0
        @map.every(1000) do
          if route = nearest_route(RoadRoute)
            if @map.elements.select {|e| e if e.is_a?(CommercialZone)}.size > 0
              create_agent(VehicleAgent, route)# if rand(0.0..1.0) > 0.9
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