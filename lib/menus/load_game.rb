module CitySim
  module Menus
    class LoadGame < CyberarmEngine::GuiState
      def setup
        label "CitySim", text_size: 58
        label "Load Game"

        background 0xff111111

        button "Back" do
          push_state(previous_state)
        end

        label "Saves", margin_top: 15

        Dir.glob("#{GAME_ROOT_PATH}/data/*.save").sort { |a, b| File.new(b).mtime <=> File.new(a).mtime}.each_with_index do |savefile, i|
          _data = JSON.parse(File.read(savefile), symbolize_names: true)

          flow(margin_bottom: 5, padding: 5) do
            background i.even? ? Gosu::Color::GRAY : 0xff222222

            stack(margin_right: 5) do
              label "#{_data[:Map_city_name]}", text_size: 28
              label "Last modified: #{File.new(savefile).mtime.strftime('%X %x')}", text_size: 18
              label "#{File.basename(savefile)}", text_size: 18
            end

            button("Load") { push_state(CitySim::Game.new(savefile: savefile)) }
            # button(
            #  "Delete",
            #  background: [0xffc11b1b, 0xff931919], border_color: [0xff631a1a, 0xff890000],
            #  hover: {background: [0xff931919, 0xffc11b1b]},
            #  active: {background: 0xffc60000}
            # )
          end
        end
      end
    end
  end
end
