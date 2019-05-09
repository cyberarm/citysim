module CitySim
  class Map
    class Route < Element
      def initialize(map, type, position)
        add_tag(:routelike)

        super
      end

      def draw
        @image.draw_rot(
          @position.x * @tile_size + @tile_size/2,
          @position.y * @tile_size + @tile_size/2,
          @position.z, @angle
        )
      end

      def connects_with
        [:routelike]
      end

      def mutate_neighbors(list)
        list.values.each do |t|
          if defined?(t.element.align_with_neighbors)
            t.element.align_with_neighbors(false)
         end
        end
      end

      def align_with_neighbors(mutate = true)
        mode = []
        list = {}

        connects_with.each do |tag|
          l = @map.neighbors(self, :four_way, tag)
          l.each do |side, tile|
            mode << side if tile
            list[side] = tile
          end
        end

        # FIXME: Stop my eyes from bleeding -_-
        case mode.size
        when 1
          case mode.first
          when :left
            @image = @sprites[:straight]
            @angle = 90
            mutate_neighbors(list) if mutate
          when :right
            @image = @sprites[:straight]
            @angle = 90
            mutate_neighbors(list) if mutate
          when :up
            @image = @sprites[:straight]
            @angle = 0
            mutate_neighbors(list) if mutate
          when :down
            @image = @sprites[:straight]
            @angle = 0
            mutate_neighbors(list) if mutate
          end

        when 2
          if mode.include?(:left) && mode.include?(:right)
            @image = @sprites[:straight]
            @angle = 90
            mutate_neighbors(list) if mutate

          elsif mode.include?(:down) && mode.include?(:up)
            @image = @sprites[:straight]
            @angle = 0
            mutate_neighbors(list) if mutate

          # CURVES
          elsif mode.include?(:left) && mode.include?(:up)
            @image = @sprites[:curve]
            @angle = 180
            mutate_neighbors(list) if mutate

          elsif mode.include?(:right) && mode.include?(:up)
            @image = @sprites[:curve]
            @angle = -90
            mutate_neighbors(list) if mutate

          elsif mode.include?(:left) && mode.include?(:down)
            @image = @sprites[:curve]
            @angle = 90
            mutate_neighbors(list) if mutate

          elsif mode.include?(:right) && mode.include?(:down)
            @image = @sprites[:curve]
            @angle = 0
            mutate_neighbors(list) if mutate
          else
            raise "RoadTool: 2-way: #{list.keys}"
          end

        when 3
          if mode.include?(:left) && mode.include?(:up) && mode.include?(:down)
            @image = @sprites[:t_intersection]
            @angle = 90
            mutate_neighbors(list) if mutate

          elsif mode.include?(:right) && mode.include?(:up) && mode.include?(:down)
            @image = @sprites[:t_intersection]
            @angle = -90
            mutate_neighbors(list) if mutate

          elsif mode.include?(:left) && mode.include?(:right) && mode.include?(:down)
            @image = @sprites[:t_intersection]
            @angle = 0
            mutate_neighbors(list) if mutate

          elsif mode.include?(:left) && mode.include?(:right) && mode.include?(:up)
            @image = @sprites[:t_intersection]
            @angle = 180
            mutate_neighbors(list) if mutate
          else
            raise "RoadTool: 3-way: #{list.keys}"
          end

        when 4
          @image = @sprites[:four_way_intersection]
          @angle = 0
          mutate_neighbors(list) if mutate
        end
      end
    end
  end
end