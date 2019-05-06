module CitySim
  class Map
    class VehicleAgent < Agent
      def setup
        @size = @map.tile_size

        @speed = 1.0
        @angle = 0
        @color = choose_body_color

        self.type = :truck
        set_goal(@map.elements.select {|e| e if e.is_a?(CommercialZone)}.sample.nearest_route(RoadRoute))
        @path = @pathfinder.path
        @current_node = @path.shift
      end

      def travels_along
        RoadRoute
      end

      def at_goal?
        !@current_node
      end

      def shift_path?
        _position = CyberarmEngine::Vector.new(@position.x.floor, @position.y.floor)
        d = @current_node.tile.position.distance(_position)
        d < @speed * @map.delta
      end

      def move_towards_goal
        direction = (@current_node.tile.position - @position)
        @position += direction.normalized * (@speed * @map.delta)

        @angle = Math.atan2(direction.y, direction.x).radians_to_gosu

        @current_node = @path.shift if shift_path?
      end

      def choose_body_color
        [
          Gosu::Color::RED,
          Gosu::Color::GREEN,
          Gosu::Color.rgb(100, 100, 255),
        ].sample
      end

      def type
        @type
      end

      def type=(type)
        @type = type

        @body_image    = get_image("assets/vehicles/#{type}_body.png")
        @overlay_image = get_image("assets/vehicles/#{type}_overlay.png")

        @image = Gosu.render(@body_image.width, @body_image.height) do
          @body_image.draw(0, 0, 0, 1, 1, @color)
          @overlay_image.draw(0, 0, 1)
        end
      end

      def draw
        return if at_goal?
        @image.draw_rot(@position.x * @map.tile_size + @map.half_tile_size, @position.y * @map.tile_size + @map.half_tile_size, 3, @angle)

        # draw_debug
      end

      def draw_debug
        node = @path.first
          Gosu.draw_line(
            @current_node.tile.position.x * @map.tile_size + @map.half_tile_size, @current_node.tile.position.y * @map.tile_size + @map.half_tile_size, @color,
            @position.x * @map.tile_size + @map.half_tile_size, @position.y * @map.tile_size + @map.half_tile_size, @color, 3
          )

        @path.each do |path|
          Gosu.draw_line(
            node.tile.position.x * @map.tile_size + @map.half_tile_size, node.tile.position.y * @map.tile_size + @map.half_tile_size, @color,
            path.tile.position.x * @map.tile_size + @map.half_tile_size, path.tile.position.y * @map.tile_size + @map.half_tile_size, @color, 3
          )

          node = path
        end
      end

      def update
        super

        remove if at_goal?
      end
    end
  end
end