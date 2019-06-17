module CitySim
  class Map
    class PowerPlantNuclearZone < PowerPlantZone
      def setup
        super
        @data[:produce_power_amount] = 150
        @data[:max_power_stored] = 150

        @image = get_image("#{GAME_ROOT_PATH}/assets/powerplants/powerplant_nuclear.png")
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