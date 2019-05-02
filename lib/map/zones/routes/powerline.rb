module CitySim
  class Map
    class PowerLineRoute < Route
      def setup
        @sprites = {
          curve:                 get_image("assets/powerlines/powerline_curve.png"),
          straight:              get_image("assets/powerlines/powerline_straight.png"),
          t_intersection:        get_image("assets/powerlines/powerline_T.png"),
          four_way_intersection: get_image("assets/powerlines/powerline_4_way.png"),
        }
        @image = @sprites[:straight]
        @angle = 0
      end

      def connects_with
        [self.class, Zone]
      end

      def color
        Tool::POWERLINE_COLOR
      end
    end
  end
end