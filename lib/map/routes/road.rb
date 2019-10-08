module CitySim
  class Map
    class RoadRoute < Route
      def setup
        add_tag(:roadlike)

        @sprites = {
          curve:                 get_image("#{GAME_ROOT_PATH}/assets/roads/road_curve.png", retro: true),
          straight:              get_image("#{GAME_ROOT_PATH}/assets/roads/road_straight.png", retro: true),
          t_intersection:        get_image("#{GAME_ROOT_PATH}/assets/roads/road_T.png", retro: true),
          four_way_intersection: get_image("#{GAME_ROOT_PATH}/assets/roads/road_4_way.png", retro: true),
        }
        @image = @sprites[:straight]
        @angle = 0
      end

      def connects_with
        [:roadlike]
      end

      def color
        Tool::ROAD_COLOR
      end
    end
  end
end