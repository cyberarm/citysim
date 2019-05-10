module CitySim
  class Map
    class PowerAgent < Agent
      def setup
        @size = @map.tile_size
        @born_time = @map.current_time
      end

      def travels_along
        :powerlinelike
      end

      def draw
        Gosu.draw_rect(
          @position.x * @map.tile_size, @position.y * @map.tile_size,
          @size, @size, Gosu::Color.rgba(255, 255, 0, 175), 2
        )
      end

      def update
        remove if @map.current_time - @born_time > 10.0
      end
    end
  end
end