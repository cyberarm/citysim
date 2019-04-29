module CitySim
  class Map
    class Zone
      def initialize(type)
        @type = type
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