module CitySim
  class Map
    class PowerAgent < Agent
      def setup
        @size = @map.tile_size
      end

      def draw
        Gosu.draw_rect(
          @position.x * @map.tile_size, @position.y * @map.tile_size,
          @size, @size, Gosu::Color.rgba(255, 255, 0, 175), 2
        )
      end
    end
  end
end