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

      def debug_draw
        @debug_colors ||= {
          :left  => Gosu::Color.rgba(0, 255, 0, 200),
          :right => Gosu::Color.rgba(0, 0, 255, 200),
          :up    => Gosu::Color.rgba(255, 255, 255, 200),
          :down  => Gosu::Color.rgba(255, 0, 0, 200)
        }
        @map.neighbors(self, :eight_way, RoadRoute).each do |side, list|
          list.each do |tile|
            Gosu.draw_rect(tile.position.x * @map.tile_size, tile.position.y * @map.tile_size, @map.tile_size, @map.tile_size, @debug_colors[side], 10)
          end
        end
      end
    end
  end
end