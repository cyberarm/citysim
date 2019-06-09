module CitySim
  class Map
    class PowerPlantCoalZone < PowerPlantZone
      def setup
        super
        @needs.goods = 5
        add_tag(:needs_goods)

        @image = get_image("#{GAME_ROOT_PATH}/assets/powerplants/powerplant_coal.png")
      end

      def draw
        super

        @image.draw(@box.min.x, @box.min.y, 0)
      end

      def label
        "Coal Power Plant"
      end

      def can_produce_power?
        @data.goods > 1
      end
    end
  end
end