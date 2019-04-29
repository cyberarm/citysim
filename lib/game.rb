module CitySim
  class Game < CyberarmEngine::GuiState
    def setup
      @active_width  = window.width
      @active_height = window.height

      @map = CitySim::Map.new
      Map::Tool.tools # setup tools
      @money = 30_000
      @citizens = []

      CyberarmEngine::Theme::THEME[:Button][:text_size] = 22
      CyberarmEngine::Theme::THEME[:Button][:border_thickness] = 1
      CyberarmEngine::Theme::THEME[:Button][:background] = Gosu::Color.rgb(100, 100, 200)
      CyberarmEngine::Theme::THEME[:Button][:border_color] = Gosu::Color.rgb(100, 100, 250)

      CyberarmEngine::Theme::THEME[:Button][:active][:color] = Gosu::Color.rgb(200, 200, 200)
      CyberarmEngine::Theme::THEME[:Button][:active][:background] = Gosu::Color.rgb(75, 75, 175)
      CyberarmEngine::Theme::THEME[:Button][:active][:border_color] = Gosu::Color.rgb(100, 100, 250)

      CyberarmEngine::Theme::THEME[:Button][:hover][:color] = Gosu::Color::WHITE
      CyberarmEngine::Theme::THEME[:Button][:hover][:background] = Gosu::Color.rgb(100, 100, 255)
      CyberarmEngine::Theme::THEME[:Button][:hover][:border_color] = Gosu::Color.rgb(100, 100, 250)

      flow(padding: 5) do
        background Gosu::Color.rgba(125,125,150, 200)
        stack(margin_left: 5, padding_right: 10) do
          label "Zones"
          flow do
            button("Residential") { @map.tool = :zone_residential }
            button("Commercial") { @map.tool = :zone_commercial }
            button("Industrial") { @map.tool = :zone_industrial }
          end
        end

        stack(padding_right: 10) do
          label "Power"
          flow do
            button("Coal") { @map.tool = :powerplant_coal }
            button("Solar") { @map.tool = :powerplant_solar }
            button("Nuclear") { @map.tool = :powerplant_nuclear }
          end
        end

        stack(padding_right: 10) do
          label "Routes"
          flow do
            button("Road") { @map.tool = :route_road }
            button("Powerline") { @map.tool = :route_powerline }
          end
        end

        stack(padding_right: 10) do
          label "Services"
          flow do
            button("Fire Department") { @map.tool = :service_fire_department }
            button("Police Department") { @map.tool = :service_police_department }
            button("City Park") { @map.tool = :service_city_park }
          end
        end

        stack do
          label "Other"
          flow do
            button("Demolish") { @map.tool = :other_demolish }
            button("No Tool") { @map.tool = nil }
          end
        end
      end

      stack do
        background Gosu::Color.rgba(125,125,150, 200)

        stack(margin: 5) do
          label "Game FPS"
          @fps_label = label "#{Gosu.fps}"

          label "Money"
          @money_label = label format_money(@money)
          label "Citizens"
          @citizens_label = label @citizens.size.to_s
        end
      end
    end

    def format_money(int, currency = "$")
      sprintf("#{currency}%.2f", int.to_f)
    end

    def draw
      super

      @map.draw
    end

    def button_down(id)
      super

      @map.button_down(id)
    end

    def button_up(id)
      super

      @map.button_up(id)
    end

    def update
      super

      @map.update
      @fps_label.value = "#{Gosu.fps}"
      @money += @map.income
      @money_label.value = format_money(@money)
      @citizens_label.value = @citizens.size.to_s
      @root_container.recalculate if @active_width != window.width || @active_height != window.height
    end
  end
end
