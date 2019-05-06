module CitySim
  class Map
    class Zone < Element
      def create_agent(agent, route, goal)
        @map.agents << agent.new(map: @map, position: route.position, goal: goal)
      end

      def nearest_route(route)
        neighbors = @map.neighbors(self, :eight_way, route)
        neighbors.values.flatten.select{|v| v.element.is_a?(route)}.sample
      end
    end
  end
end