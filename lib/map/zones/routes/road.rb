module CitySim
  class Map
    class RoadRoute < Route
      def setup
        @sprites = {
          curve:                get_image("assets/road_curve.png"),
          straight:             get_image("assets/road.png"),
          t_intersection:       get_image("assets/road_T.png"),
          four_way_intersection: get_image("assets/road_4_way.png"),
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