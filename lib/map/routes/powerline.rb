module CitySim
  class Map
    class PowerLineRoute < Route
      def setup
        add_tag(:powerlinelike)

        @sprites = {
          curve:                 get_image("#{GAME_ROOT_PATH}/assets/powerlines/powerline_curve.png", retro: true),
          straight:              get_image("#{GAME_ROOT_PATH}/assets/powerlines/powerline_straight.png", retro: true),
          t_intersection:        get_image("#{GAME_ROOT_PATH}/assets/powerlines/powerline_T.png", retro: true),
          four_way_intersection: get_image("#{GAME_ROOT_PATH}/assets/powerlines/powerline_4_way.png", retro: true),
        }
        @image = @sprites[:straight]
        @angle = 0
        @position.z = 4
      end

      def connects_with
        [:powerlinelike, :zonelike]
      end

      def color
        Tool::POWERLINE_COLOR
      end
    end
  end
end