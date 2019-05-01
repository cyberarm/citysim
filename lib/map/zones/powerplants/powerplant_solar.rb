module CitySim
  class Map
    class PowerPlantSolarZone < PowerPlantZone
      def setup
        @image = get_image("assets/powerplants/powerplant_solar.png")
      end

      def draw
        super

        @tiles.each do |tile|
          @image.draw(tile.position.x * @map.tile_size, tile.position.y * @map.tile_size, 0)
        end
      end
    end
  end
end