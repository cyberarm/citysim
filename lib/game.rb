module CitySim
  class Game < CyberarmEngine::GuiState
    attr_reader :money, :citizens
    def setup
      @map = CitySim::Map.new(game: self, savefile: @options[:savefile])

      # TODO: Implement a styling system
      theme = {}
      theme[:Button] = {}
      theme[:Button][:active] = {}
      theme[:Button][:hover]  = {}

      theme[:Button][:text_size] = 23
      theme[:Button][:border_thickness] = 1
      theme[:Button][:margin] = 3
      theme[:Button][:padding] = 4
      theme[:Button][:background] = Gosu::Color.rgb(100, 100, 200)
      theme[:Button][:border_color] = Gosu::Color.rgb(100, 100, 250)

      theme[:Button][:active][:color] = Gosu::Color.rgb(200, 200, 200)
      theme[:Button][:active][:background] = Gosu::Color.rgb(75, 75, 175)
      theme[:Button][:active][:border_color] = Gosu::Color.rgb(100, 100, 250)

      theme[:Button][:hover][:color] = Gosu::Color::WHITE
      theme[:Button][:hover][:background] = Gosu::Color.rgb(100, 100, 255)
      theme[:Button][:hover][:border_color] = Gosu::Color.rgb(100, 100, 250)

      theme(theme)

      @toolbar = flow(padding: 5, width: 1.0) do |f|
        background Gosu::Color.rgba(125,125,150, 200)
        stack(margin_right: 5) do |s|
          label "Zones"
          flow do
            button("Residential"){ @map.tool = :zone_residential }
            button("Commercial") { @map.tool = :zone_commercial }
            button("Industrial") { @map.tool = :zone_industrial }
          end
        end

        stack(margin_right: 5) do
          label "Power"
          flow do
            button("Coal")    { @map.tool = :powerplant_coal }
            button("Solar")   { @map.tool = :powerplant_solar }
            button("Nuclear") { @map.tool = :powerplant_nuclear }
          end
        end

        stack(margin_right: 5) do
          label "Routes"
          flow do
            button("Road")      { @map.tool = :route_road }
            button("Powerline") { @map.tool = :route_powerline }
          end
        end

        stack(margin_right: 5) do
          label "Services"
          flow do
            button("Fire Department")   { @map.tool = :service_fire_department }
            button("Police Department") { @map.tool = :service_police_department }
            button("City Park")         { @map.tool = :service_city_park }
          end
        end

        stack(margin_right: 5) do
          label "Other"
          flow do
            button("Demolish") { @map.tool = :other_demolish }
            button("No Tool")  { @map.tool = nil }
          end
        end

        stack do
          label "Time"
          flow do
            button("▐ ▌") { @map.speed = 0.0 }
            button("1x")  { @map.speed = 1.0 }
            button("5x")  { @map.speed = 5.0 }
            button("10x") { @map.speed = 10.0 }
          end
        end
      end

      @info_bar = stack do
        background Gosu::Color.rgba(125,125,150, 200)

        stack(margin: 5) do
          label "#{@map.city_name}", color: Gosu::Color::BLACK
          label "", text_size: 18

          label "Game FPS"
          @fps_label = label "#{Gosu.fps}", text_size: 22

          label "Time"
          @time_label = label @map.current_time, text_size: 22
          label "Money"
          @money_label = label format_money(@map.money), text_size: 22
          label "Citizens"
          @citizens_label = label 0, text_size: 22
          label "Agents"
          @agents_label = label 0, text_size: 22
        end

        @debug_info_bar = stack(margin: 5) do
          label "DEBUG", text_size: 26, color: Gosu::Color.rgb(255, 75, 0)
          @debug_zoom_label = label "Zoom"
          @debug_grid_coord_label = label "Grid Coord."
        end
        @debug_info_bar.hide
      end
    end

    def format_money(int, currency = "$")
      list = []
      number = int.to_f.to_s.split(".")
      number.first.reverse.chars.each_slice(3) {|slice| list << slice}

      number[0] = list.map(&:join).join(",").reverse

      "#{currency}#{number.first}.00"
    end

    def mouse_over_menu?
      @toolbar.hit?(window.mouse_x, window.mouse_y) || @info_bar.hit?(window.mouse_x, window.mouse_y)
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
      @money_label.value = format_money(@map.money)
      # @citizens_label.value = @map.citizens.size.to_s
      @agents_label.value = @map.agents.size.to_s
      @time_label.value = @map.current_time.strftime("%Y-%m-%d %H:%M:%S")

      if Setting.enabled?(:debug_info_bar)
        @debug_info_bar.show unless @debug_info_bar.visible?

        @debug_zoom_label.value = "Zoom #{@map.scale}"
        @debug_grid_coord_label.value = "Grid Coord. #{@map.grid_x}:#{@map.grid_y}"
      else
        @debug_info_bar.hide if @debug_info_bar.visible?
      end
    end
  end
end
