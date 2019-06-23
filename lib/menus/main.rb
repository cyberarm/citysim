module CitySim
  module Menus
    class Main < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58

        background 0xff111111

        button("New Game") { push_state(CitySim::Menus::NewGame) }
        button("Load Game") { push_state(CitySim::Menus::LoadGame) }
        button("Settings") { push_state(CitySim::Menus::Settings) }
        button("Exit") { $window.close }

        flow(margin_top: 10) do
          stack(border_color: Gosu::Color::WHITE, border_thickness: 1) do
            label "<b><i>CitySim</i> V#{CitySim::VERSION} #{CitySim::RELEASE_NAME}</b>", text_size: 14
            label "Running on <b><i>CyberarmEngine</i> V#{CyberarmEngine::VERSION} #{CyberarmEngine::NAME}</b>", text_size: 14
          end
          stack(border_color: Gosu::Color::WHITE, border_thickness: 1) do
            label "Built using <b>libgosu</b> - libgosu.org", text_size: 14, bold: true
            label "Written in <b>Ruby</b> - ruby-lang.org", text_size: 14
          end
        end
      end
    end
  end
end
