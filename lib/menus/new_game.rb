module CitySim
  module Menus
    class NewGame < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58
        label "New Game"

        @name = edit_line "Centerville"
        @rows = edit_line "33"
        @columns = edit_line "33"

        flow do
          button "Back" do
            push_state(previous_state)
          end
          button "Create" do
            push_state(CitySim::Game)
          end
        end
      end
    end
  end
end
