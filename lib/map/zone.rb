module CitySim
  class Map
    class Zone
      include CyberarmEngine::Common

      attr_reader :position
      def initialize(map, type, position)
        @map  = map
        @type = type
        @position = position

        @tile_size = @map.tile_size

        setup
      end

      def setup
      end

      def type
        @type
      end

      def color
        Gosu::Color::CYAN
      end

      def draw
      end

      def update
      end
    end
  end
end