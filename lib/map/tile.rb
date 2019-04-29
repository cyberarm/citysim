module CitySim
  class Map
    class Tile
      attr_accessor :zone, :route
      def initialize(type: :land, color: Tile::LAND, zone: nil, route: nil)
        @type = type
        @color= color
        @zone, @route = zone, route
      end

      def type
        @type
      end

      def color
        if @zone
          @zone.color
        elsif @route
          @route.color
        else
          @color
        end
      end

      def element
        @zone ? @zone : @route
      end

      def available?
        !@zone && !@route
      end
    end
  end
end