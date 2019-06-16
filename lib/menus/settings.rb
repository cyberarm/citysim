module CitySim
  module Menus
    class Settings < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58
        label "Settings", text_size: 36

        stack(margin: 5) do

          label "New Game"
          stack do
            background 0xff005500
            flow do
              label "Default Map Name"
              @default_map_name = edit_line Setting.get(:default_map_name)
            end
            flow do
              label "Default Map Width"
              @default_map_width = edit_line Setting.get(:default_map_width)
            end
            flow do
              label "Default Map Height"
              @default_map_height = edit_line Setting.get(:default_map_height)
            end
          end

          label "Debugging", margin_top: 15
          stack do
            background 0xffff5500
            @debug_pathfinding = check_box "Pathfinding", checked: Setting.enabled?(:debug_pathfinding)
            @debug_mode        = check_box "Show edges", checked: Setting.enabled?(:debug_mode)
            @debug_info_bar    = check_box "Info Bar", checked: Setting.enabled?(:debug_info_bar)
          end

          @error = label "", margin_top: 15, color: 0xffff5500
        end

        flow do
          button("Cancel") { pop_state }
          button("Save") { pop_state if saved_settings }
        end
      end

      def saved_settings
        return unless valid_options?

        Setting.set(:default_map_name, @default_map_name.value)
        Setting.set(:default_map_width, @default_map_width.value)
        Setting.set(:default_map_height, @default_map_height.value)

        Setting.set(:debug_mode, @debug_mode.value)
        Setting.set(:debug_pathfinding, @debug_pathfinding.value)
        Setting.set(:debug_info_bar, @debug_info_bar.value)

        Setting.save!
      end

      def valid_options?
        if @default_map_name.value.length == 0
          @error.value = "Default City Name must not be empty!"
          return false

        elsif @default_map_width.value.length == 0
          @error.value = "Default Map Width must not be empty!"
          return false

        elsif @default_map_height.value.length == 0
          @error.value = "Default Map Height must not be empty!"
          return false

        elsif @default_map_width.value.to_i / 3.0 % 1 != 0
          @error.value = "Default Map Width must divisable by 3!"
          return false

        elsif @default_map_height.value.to_i / 3.0 % 1 != 0
          @error.value = "Default Map Height must divisable by 3!"
          return false

        elsif @default_map_width.value.to_i < 3
          @error.value = "Default Map Width must br greater then or equal to 3!"
          return false

        elsif @default_map_height.value.to_i < 3
          @error.value = "Default Map Height must br greater then or equal to 3!"
          return false

        else
          return true
        end
      end

      def draw
        fill 0xff111111

        super
      end
    end
  end
end
