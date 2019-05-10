module CitySim
  class Map
    class RoadTool < Tool
      def places
        :route_road
      end

      def type
        :route
      end

      def can_use?(x, y)
        able = true

        each_tile(x, y) do |_x, _y, _tile|
          unless _tile
            able = false
            next
          end
          next if _tile.available?

          unless _tile.element.has_tag?(:powerlinelike) && !_tile.element.has_tag?(:roadlike)
            able = false
          end
        end

        return able
      end

      def use(x, y, element)
        unless @map.grid.dig(x, y).available?
          element = RoadAndPowerlineRoute.new(@map, :route_road, CyberarmEngine::Vector.new(x, y))
        end

        tiles = []
        each_tile(x, y) do |_x, _y, _tile|
          tiles << _tile
          _tile.send(:"#{type}=", element)
        end

        element.tiles = tiles
        @map.elements << element

        element.align_with_neighbors
      end

      def color
        Tool::ROAD_COLOR
      end

      def cost
        Tool::ROAD_COST
      end

      def rows
        1
      end

      def columns
        1
      end
    end
  end
end