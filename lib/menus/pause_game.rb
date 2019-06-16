module CitySim
  module Menus
    class PauseGame < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58
        label "Pause Game"

        button "Save" do
          @options[:map].save_level
          push_state(previous_state)
        end

        button "Settings" do
          push_state(Settings)
        end

        button "Save and Quit" do
          @options[:map].save_level
          push_state(Main)
        end


        button "Resume" do
          push_state(previous_state)
        end

        def draw
          previous_state.draw
          Gosu.flush

          Gosu.draw_rect(0, 0, window.width, window.height, Gosu::Color.rgba(50, 50, 50, 200))

          super
        end

        def button_up(id)
          super(id)

          push_state(previous_state) if id == Gosu::KbEscape
        end
      end
    end
  end
end
