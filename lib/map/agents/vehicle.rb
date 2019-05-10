module CitySim
  class Map
    class VehicleAgent < Agent
      @@cache = {}

      def setup
        @size = @map.tile_size

        @angle = 0
        @color = choose_body_color

        self.type = :truck
        @bounding_box = CyberarmEngine::BoundingBox.new(
          @position - @image.width/2,
          @position - @image.height/2,
        )

        @min_distance = 0.1

        @max_speed = 1.0
        @max_force = 1.0
        @mass = 100.0

        @velocity = CyberarmEngine::Vector.new
        @seeking  = CyberarmEngine::Vector.new

        @path = @pathfinder.path
        @path_index = 0
        @current_node = @path[@path_index]
        if @current_node
          @seeking = @current_node.tile.position.clone
          set_lane_offset
        end
      end

      def travels_along
        :roadlike
      end

      def at_goal?
        !@current_node
      end

      def shift_path?
        _position = CyberarmEngine::Vector.new(@position.x, @position.y)
        d = @seeking.distance(_position)
        d <= @min_distance
      end

      def can_move?
        direction = (@seeking - @position)
        @position + direction.normalized * (@velocity * @map.delta)
      end

      def move_towards_goal
        return unless can_move?
        direction = (@seeking - @position)

        @velocity = direction.normalized * @max_speed

        @position += @velocity * @map.delta

        @angle = Math.atan2(direction.y, direction.x).radians_to_gosu

        if shift_path?
          @path_index  += 1
          @current_node = @path[@path_index]
          @seeking = @current_node.tile.position.clone if @current_node
          set_lane_offset if @current_node
        end
      end

      def set_lane_offset
        lane_offset = CyberarmEngine::Vector.new
        offset = 0.25

        next_node = @path[@path_index+1]
        if next_node
          direction = (next_node.tile.position - @seeking).normalized
          if direction.x < 0
            lane_offset.y -= offset
          elsif direction.x > 0
            lane_offset.y += offset
          end

          if direction.y < 0
            lane_offset.x += offset
          elsif direction.y > 0
            lane_offset.x -= offset
          end
        end

        @seeking += lane_offset
      end

      def choose_body_color
        [
          Gosu::Color.rgb(153, 102, 255), # Purple-ish
          Gosu::Color.rgb(255, 127, 50), # Orange-ish
          Gosu::Color::WHITE,
        ].sample
      end

      def type
        @type
      end

      def type=(type)
        @type = type

        @image = image_from_cache
      end

      # cache assembled vehicle images
      def image_from_cache
        unless @@cache.dig(@type, @color)
          @@cache[@type] ||= {}
          body_image    = get_image("#{GAME_ROOT_PATH}/assets/vehicles/#{type}_body.png")
          overlay_image = get_image("#{GAME_ROOT_PATH}/assets/vehicles/#{type}_overlay.png")

          image = Gosu.render(body_image.width, body_image.height) do
            body_image.draw(0, 0, 0, 1, 1, @color)
            overlay_image.draw(0, 0, 1)
          end
          @@cache[@type][@color] = image
        end

        return @@cache.dig(@type, @color)
      end

      def draw
        return if at_goal?
        @image.draw_rot(@position.x * @map.tile_size + @map.half_tile_size, @position.y * @map.tile_size + @map.half_tile_size, 3, @angle)

        debug_draw if Setting.enabled?(:debug_pathfinding)
      end

      def debug_draw
        Gosu.draw_line(
          @current_node.tile.position.x * @map.tile_size + @map.half_tile_size, @current_node.tile.position.y * @map.tile_size + @map.half_tile_size, @color,
          @position.x * @map.tile_size + @map.half_tile_size, @position.y * @map.tile_size + @map.half_tile_size, @color, 3
        )

        node = @path[@path_index]
        @path[@path_index..@path.size - 1].each do |path|
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