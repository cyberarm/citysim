module CitySim
  class Map
    class RoadRoute < Route
      def setup
        @roads = {
          straight:             get_image("assets/road.png"),
          t_intersection:       get_image("assets/road_T.png"),
          four_way_intersection: get_image("assets/road_4_way.png"),
        }
        @image = @roads[:straight]
        @angle = 0
      end

      def color
        Tool::ROAD_COLOR
      end

      def draw
        @image.draw_rot(
          @position.x * @tile_size + @tile_size/2,
          @position.y * @tile_size + @tile_size/2,
          0, @angle
        )
      end

      def align_with_neighbors(mutate = true)
        list = @map.neighbors(self, :four_way, self.class)

        mode = []
        list.each do |side, tile|
          mode << side if tile
          # puts "#{side}->#{tile.element}"
        end

        # FIXME: Stop my eyes from bleeding -_-
        case mode.size
        when 1
          case mode.first
          when :left
            @image = @roads[:straight]
            @angle = 90
            list.values.each {|l| l.element.align_with_neighbors(false)} if mutate
          when :right
            @image = @roads[:straight]
            @angle = 90
            list.values.each {|l| l.element.align_with_neighbors(false)} if mutate
          when :up
            @image = @roads[:straight]
            @angle = 0
            list.values.each {|l| l.element.align_with_neighbors(false)} if mutate
          when :down
            @image = @roads[:straight]
            @angle = 0
            list.values.each {|l| l.element.align_with_neighbors(false)} if mutate
          end

        when 2
          if mode.include?(:left) && mode.include?(:right)
            @image = @roads[:straight]
            @angle = 90
          elsif mode.include?(:down) && mode.include?(:up)
            @image = @roads[:straight]
          elsif mode.include?(:left) && mode.include?(:up)
            @image = @roads[:t_intersection]
            @angle = 180
            list[:left].element.align_with_neighbors(false) if mutate
            list[:up].element.align_with_neighbors(false) if mutate
          elsif mode.include?(:right) && mode.include?(:up)
            @image = @roads[:t_intersection]
            @angle = 180
            list[:right].element.align_with_neighbors(false) if mutate
            list[:up].element.align_with_neighbors(false) if mutate
          elsif mode.include?(:left) && mode.include?(:down)
            @image = @roads[:t_intersection]
            @angle = 90
            list[:left].element.align_with_neighbors(false) if mutate
            list[:down].element.align_with_neighbors(false) if mutate
          elsif mode.include?(:right) && mode.include?(:down)
            @image = @roads[:t_intersection]
            @angle = -90
            list[:right].element.align_with_neighbors(false) if mutate
            list[:down].element.align_with_neighbors(false) if mutate
          else
            raise mode
          end

        when 3
          puts :triggered_3way
        when 4
          @image = @roads[:four_way_intersection]
        end
      end
    end
  end
end