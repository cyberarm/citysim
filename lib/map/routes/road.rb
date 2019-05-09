module CitySim
  class Map
    class RoadRoute < Route
      def setup
        @sprites = {
          curve:                 get_image("#{GAME_ROOT_PATH}/assets/roads/road_curve.png"),
          straight:              get_image("#{GAME_ROOT_PATH}/assets/roads/road_straight.png"),
          t_intersection:        get_image("#{GAME_ROOT_PATH}/assets/roads/road_T.png"),
          four_way_intersection: get_image("#{GAME_ROOT_PATH}/assets/roads/road_4_way.png"),
        }
        @image = @sprites[:straight]
        @angle = 0
      end

      def color
        Tool::ROAD_COLOR
      end
    end
  end
end