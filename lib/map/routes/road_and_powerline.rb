module CitySim
  class Map
    class RoadAndPowerlineRoute < Route
      def setup
        @type = :route_road_and_powerline

        if @map.grid.dig(@position.x, @position.y).element.is_a?(RoadRoute)
          @road = @map.grid.dig(@position.x, @position.y).element
          @powerline = PowerLineRoute.new(@map, :route_powerline, @position)
          @map.elements.delete(@road)
          @map.elements.delete(@powerline)

        elsif @map.grid.dig(@position.x, @position.y).element.is_a?(PowerLineRoute)
          @road = RoadRoute.new(@map, :route_road, @position)
          @powerline = @map.grid.dig(@position.x, @position.y).element
          @map.elements.delete(@road)
          @map.elements.delete(@powerline)
        else
          raise "Doubling up is only allowed for Roads and Powerlines!"
        end

        add_tag(:powerlinelike)
        add_tag(:roadlike)
      end

      def draw
        @road.draw
        @powerline.draw
      end

      def align_with_neighbors(mutate = true)
        @road.align_with_neighbors(mutate)
        @powerline.align_with_neighbors(mutate)
      end

      def color
        Tool::ROAD_COLOR
      end
    end
  end
end