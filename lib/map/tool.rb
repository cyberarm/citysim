module CitySim
  class Map
    class Tool
      RESIDENTIAL_COLOR = Gosu::Color.rgba(25, 200, 25, 150)
      COMMERCIAL_COLOR  = Gosu::Color.rgba(25, 25, 255, 150)
      INDUSTRIAL_COLOR  = Gosu::Color.rgba(255, 25, 25, 150)

      ROAD_COLOR      = Gosu::Color.rgba(50, 50, 50, 150)
      POWERLINE_COLOR = Gosu::Color.rgba(255, 255, 25, 150)

      POWERPLANT_COLOR        = Gosu::Color.rgba(255, 255, 25, 150)
      CITY_PARK_COLOR         = Gosu::Color.rgba(255, 127, 25, 150)
      FIRE_DEPARTMENT_COLOR   = Gosu::Color.rgba(255, 0, 127, 150)
      POLICE_DEPARTMENT_COLOR = Gosu::Color.rgba(255, 127, 127, 150)

      DEMOLISH_COLOR = Gosu::Color.rgba(200, 45, 32, 150)

      RESIDENTIAL_COST = 100
      COMMERCIAL_COST  = 100
      INDUSTRIAL_COST  = 250

      ROAD_COST      = 10
      POWERLINE_COST = 25

      POWERPLANT_COAL_COST   = 3_000
      POWERPLANT_SOLAR_COST  = 7_500
      POWERPLANT_NUCLEAR_COST= 10_000

      CITY_PARK_COST         = 500
      FIRE_DEPARTMENT_COST   = 1_000
      POLICE_DEPARTMENT_COST = 1_500

      def self.tools(map = nil)
        unless @tools
          raise "Map instance not received!" unless map.is_a?(Map)
          @tools = {}

          @list.each do |subclass|
            instance = subclass.new(map)
            raise "Tool #{instance.places.inspect} already defined!" if @tools[instance.places]
            @tools[instance.places] = instance
          end
        end

        @tools
      end

      def self.inherited(subclass)
        @list ||= []
        @list << subclass
      end

      def initialize(map)
        @map = map
      end

      def places
        nil
      end

      def demolishes?
        false
      end

      def type
        :zone
      end

      def use(x, y, element)
        each_tile(x, y) do |_x, _y, _tile|
          _tile.send(:"#{type}=", element)
        end
      end

      def can_use?(x, y)
        able = true

        each_tile(x, y) do |_x, _y, _tile|
          able = false if _tile.nil? || !_tile.available?
        end

        return able
      end

      # Iterate over each tile affected by tool and call block for each tile
      def each_tile(x, y, &block)
        columns.times do |_y|
          rows.times do |_x|
            gx = (@map.tile_size * x - ((rows/2.0).floor    * @map.tile_size)) + _x * @map.tile_size
            gy = (@map.tile_size * y - ((columns/2.0).floor * @map.tile_size)) + _y * @map.tile_size

            _tile = @map.grid.dig(gx / @map.tile_size, gy / @map.tile_size)
            block.call(gx, gy, _tile)
          end
        end
      end

      def cost
        raise "#{self.class}#cost is not set!"
      end

      def color
        Gosu::Color.rgba(100, 100, 150, 100)
      end

      def rows
        raise "#{self.class}#rows not overridden!"
      end

      def columns
        raise "#{self.class}#columns not overridden!"
      end
    end
  end
end