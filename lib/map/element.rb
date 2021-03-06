module CitySim
  class Map
    class Element
      include CyberarmEngine::Common
      include CitySim::Taggable

      attr_reader :map, :position, :tiles, :box, :data, :runtime_data
      def initialize(map, type, position)
        @map  = map
        @type = type
        @position = position # in grid coordinates
        @data = {}
        @runtime_data = {} # data which only lives while game is running

        @tiles = []
        @tile_size = @map.tile_size

        @box = CyberarmEngine::BoundingBox.new

        @font = CyberarmEngine::Text.new(label, size: 26, shadow: false, z: -1)


        @data[:power]     = 0
        @data[:max_power] = 0

        @data[:residents]     = 0
        @data[:max_residents] = 0

        @data[:workers]     = 0
        @data[:max_workers] = 0

        @data[:shoppers]     = 0
        @data[:max_shoppers] = 0

        @data[:goods]     = 0
        @data[:max_goods] = 0

        setup
      end

      def setup
      end

      def type
        @type
      end

      def tiles=(list)
        @tiles = list
        update_bounding_box
      end

      def color
        Gosu::Color::CYAN
      end

      def label
        "? ? ?"
      end

      def draw
        size = @box.max - @box.min
        Gosu.draw_rect(@box.min.x, @box.min.y, size.x, size.y, opacity(color, 0.25), -1)
        bb_min = @box.min + 1
        bb_max = @box.max - 1
        Gosu.draw_line(
          bb_min.x, bb_min.y, color, # TOP
          bb_max.x, bb_min.y, color, 0
        )
        Gosu.draw_line(
          bb_min.x, bb_min.y, color, # LEFT
          bb_min.x, bb_max.y, color, 0
        )
        Gosu.draw_line(
          bb_max.x, bb_min.y, color, # RIGHT
          bb_max.x, bb_max.y, color, 0
        )
        Gosu.draw_line(
          bb_min.x, bb_max.y, color, # BOTTOM
          bb_max.x, bb_max.y, color, 0
        )

        @font.draw

        debug_draw if Setting.enabled?(:debug_mode)
      end

      def debug_draw
      end

      def update
      end

      def update_bounding_box
        min = @tiles.sample.position.clone
        max = @tiles.sample.position.clone

        @tiles.each do |tile|
          pos = tile.position
          min.x = pos.x if pos.x < min.x
          min.y = pos.y if pos.y < min.y

          max.x = pos.x if pos.x > max.x
          max.y = pos.y if pos.y > max.y
        end

        @box = CyberarmEngine::BoundingBox.new(min * @map.tile_size, (max + 1) * @map.tile_size)

        bb_min = @box.min + 1
        bb_max = @box.max - 1
        size_bb = bb_max - bb_min
        @font.x, @font.y = bb_max.x - size_bb.x / 2 - @font.width / 2, bb_max.y - size_bb.y / 2 - @font.height / 2
      end

      def dump
        {
          type: @type,
          position: @position.to_h,
          data: @data,
        }
      end

      def load(hash)
        @data.merge!(hash[:data]) if hash[:data]
      end
    end
  end
end