module CitySim
  class Map
    class PowerPlantNuclearZone < PowerPlantZone
      def setup
        super
        @image = get_image("assets/powerplants/powerplant_nuclear.png")
      end

      def draw
        super

        @image.draw(@box.min.x, @box.min.y, 0)
      end

      def label
        "Nuclear Power Plant"
      end
    end
  end
end