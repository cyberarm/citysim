module CitySim
  module Menus
    class NewGame < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58
        label "New Game"

        background 0xff111111

        flow do
          label "City Name"
          @name = edit_line Setting.get(:default_map_name)
        end

        flow do
          label "Map Width"
          @rows = edit_line Setting.get(:default_map_width)
        end
        flow do
          label "Map Height"
          @columns = edit_line Setting.get(:default_map_height)
        end

        @error = label "", color: Gosu::Color::RED
        flow do
          button "Back" do
            push_state(previous_state)
          end
          button "Create" do
            if valid_options?
              window.text_input = nil
              push_state(CitySim::Game.new(map_name: "#{@name.value}", map_rows: @rows.value.to_i, map_columns: @columns.value.to_i))
            end
          end
        end

        def valid_options?
          if @name.value.length == 0
            @error.value = "City Name must not be empty!"
            return false

          elsif File.exist?("#{GAME_ROOT_PATH}/data/#{Map::Store::Level.safe_filename(@name.value)}.save")
            @error.value = "Map with name: #{@name.value} (#{Map::Store::Level.safe_filename(@name.value)}) already exists!"
            return false

          elsif @rows.value.length == 0
            @error.value = "Map Rows must not be empty!"
            return false

          elsif @columns.value.length == 0
            @error.value = "Map Columns must not be empty!"
            return false

          elsif @rows.value.to_i / 3.0 % 1 != 0
            @error.value = "Map Rows must divisable by 3!"
            return false

          elsif @columns.value.to_i / 3.0 % 1 != 0
            @error.value = "Map Columns must divisable by 3!"
            return false

          elsif @rows.value.to_i < 3
            @error.value = "Map Rows must br greater then or equal to 3!"
            return false

          elsif @columns.value.to_i < 3
            @error.value = "Map Columns must br greater then or equal to 3!"
            return false

          else
            return true
          end
        end
      end
    end
  end
end
