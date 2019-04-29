module CitySim
  class Map
    class Tile
      LAND  = :land
      WATER = :water
      LAND_COLOR  = Gosu::Color.rgb(25, 150, 15)
      WATER_COLOR = Gosu::Color.rgb(0, 15, 150)

      attr_accessor :zone, :route
      def initialize(type:, color:, zone: nil, route: nil)
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

      def free
        @zone = nil
        @route= nil
      end

      def available?
        !@zone && !@route
      end
    end
  end
end