module CitySim
  class Map
    class Zone < Element
      def create_agent(agent, route)
        @map.agents << agent.new(map: @map, position: route.position)
      end

      def nearest_route(route)
        neighbors = @map.neighbors(self, :eight_way, route)
        neighbors.values.flatten.map{|v| v.element}.sample
      end
    end
  end
end