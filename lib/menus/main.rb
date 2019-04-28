module CitySim
  module Menus
    class Main < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58

        button("Play") { push_state(CitySim::Game) }
        button("Exit") { $window.close }

        flow(margin_top: 10) do
          label "<b><i>CitySim</i> V0.1.0 InDev</b>", text_size: 14, border_color: Gosu::Color::WHITE, border_thickness: 1
          stack(border_color: Gosu::Color::WHITE, border_thickness: 1) do
            label "Built using <b>libgosu</b> - libgosu.org", text_size: 14, bold: true
            label "Written in <b>Ruby</b> - ruby-lang.org", text_size: 14
          end
        end
      end
    end
  end
end
