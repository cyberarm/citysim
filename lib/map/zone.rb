module CitySim
  class Map
    class Zone
      def initialize(type)
        @type = type
        @map  = nil
      end

      def map=(_map)
        @map = _map
      end

      def type
        @type
      end

      def color
        Gosu::Color::CYAN
      end

      def update
      end
    end
  end
end