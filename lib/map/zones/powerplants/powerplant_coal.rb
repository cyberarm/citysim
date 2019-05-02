module CitySim
  class Map
    class PowerPlantCoalZone < PowerPlantZone
      def setup
        @image = get_image("assets/powerplants/powerplant_coal.png")
      end

      def draw
        super

        @image.draw(@box.min.x, @box.min.y, 0)
      end

      def label
        "Coal Power Plant"
      end
    end
  end
end