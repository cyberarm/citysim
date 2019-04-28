module CitySim
  class Game < CyberarmEngine::GuiState
    def setup
      @active_width  = window.width
      @active_height = window.height

      @map = CitySim::Map.new(rows: 32, columns: 32)
      Map::Tool.tools # setup tools

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

      background Gosu::Color.rgba(125,125,150, 200)
      flow do
        stack(padding_right: 10) do
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

        stack(padding_right: 10) do
          label "Other"
          flow do
            button("Demolish") { @map.tool = :other_demolish }
            button("No Tool") { @map.tool = nil }
          end
        end
      end
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
      @root_container.recalculate if @active_width != window.width || @active_height != window.height
    end
  end
end
