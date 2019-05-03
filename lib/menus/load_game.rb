module CitySim
  module Menus
    class LoadGame < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58
        label "Load Game"

        button "Back" do
          push_state(previous_state)
        end

        Dir.glob("data/*.save").each do |name|
          button(File.basename(name, '.save')) { push_state(CitySim::Game.new(savefile: name)) }
        end
      end
    end
  end
end
