module CitySim
  class Map
    class Tool
      RESIDENTIAL_COLOR = Gosu::Color.rgba(25, 200, 25, 150)
      COMMERCIAL_COLOR  = Gosu::Color.rgba(25, 25, 255, 150)
      INDUSTRIAL_COLOR  = Gosu::Color.rgba(255, 25, 25, 150)

      ROAD_COLOR      = Gosu::Color.rgba(0, 0, 0, 150)
      POWERLINE_COLOR = Gosu::Color.rgba(255, 255, 25, 150)

      POWERPLANT_COLOR = Gosu::Color.rgba(255, 255, 25, 150)
      CITY_PARK_COLOR = Gosu::Color.rgba(255, 127, 25, 150)
      FIRE_DEPARTMENT_COLOR = Gosu::Color.rgba(255, 0, 127, 150)
      POLICE_DEPARTMENT_COLOR = Gosu::Color.rgba(255, 127, 127, 150)

      def self.tools
        unless @tools
          @tools = {}

          @list.each do |subclass|
            instance = subclass.new
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

      def places
        nil
      end

      def demolishes?
        false
      end

      def type
        :zone
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