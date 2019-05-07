module CitySim
  class Map
    class DemolishTool < Tool
      def places
        :other_demolish
      end

      def type
        :demolition
      end

      def use(x, y, element)
        destroy_element(x, y)
      end

      def can_use?(x, y)
        @map.active_tile.element
      end

      def destroy_element(x, y)
        _tile = @map.active_tile
        return unless _tile
        return unless _tile.element

        return unless @map.money >= cost

        element = @map.elements.delete(_tile.element)
        @map.grid_each do |tile, x, y|
          if tile.element == element
            tile.free
          end
        end

        @map.removed(element)
        element.align_with_neighbors if element.is_a?(Route)
        @map.charge(cost)
      end

      def draw
        return unless tile = @map.active_tile
        tool = tile.element ? Map::Tool.tools.dig(tile.element.type) : nil

        if tile.element && tool
          tile.element.tiles.each do |tile|
            Gosu.draw_rect(
              tile.position.x * @map.tile_size, tile.position.y * @map.tile_size,
              @map.tile_size, @map.tile_size,
              color
            )
          end
        else
          each_tile(@map.grid_x , @map.grid_y) do |gx, gy, _tile|
            Gosu.draw_rect(
              gx, gy,
              @map.tile_size, @map.tile_size,
              Tool::NO_DEMOLISH_COLOR
            )
          end
        end
      end

      def color
        Tool::DEMOLISH_COLOR
      end

      def cost
        tile = @map.active_tile
        if tile && tile.element
          tool = Map::Tool.tools.dig(tile.element.type)
          tool.cost * 0.1 # 10% of original price
        else
          0
        end
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