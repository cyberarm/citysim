module CitySim
  class Map
    attr_reader :residents
    class ResidentialZone < Zone
      def setup
        @residents = 0
      end

      def color
        Tool::RESIDENTIAL_COLOR
      end

      def update
      end
    end
  end
end