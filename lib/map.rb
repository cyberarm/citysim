module CitySim
  class Map
    include CyberarmEngine::Common

    def initialize(rows: 33, columns: 33, tile_size: 16)
      @rows, @columns = rows, columns
      @tile_size = tile_size

      @tool = nil
      @grid = {}
      @elements = []

      @drag_start = nil
      @drag_speed = 0.1
      @offset = CyberarmEngine::Vector.new

      @income = 0
      @outcome= 0

      @default_tile = :land
      @green = Gosu::Color.rgb(25, 150, 15)

      generate_map
      position_map
    end

    def generate_map
      @columns.times do |y|
        @rows.times do |x|
          @grid[x] ||= {}
          @grid[x][y] = Tile.new(type: @default_tile, color: vary_color(@green))
        end
      end
    end

    # Center map on screen
    def position_map
      @offset.x = normalize(window.width/2  - width/2)  * @tile_size
      @offset.y = normalize(window.height/2 - height/2) * @tile_size
    end

    def grid_each(&block)
      @columns.times do |y|
        @rows.times do |x|
          tile = @grid.dig(x, y)
          next unless tile

          block.call(tile, x, y)
        end
      end
    end

    def width; @rows * @tile_size; end
    def height; @columns * @tile_size; end

    def tool=(type)
      @tool = type
    end

    def draw
      Gosu.translate(@offset.x, @offset.y) do
        @columns.times do |y|
          @rows.times do |x|
            Gosu.draw_rect(x * @tile_size, y * @tile_size, @tile_size, @tile_size, @grid[x][y].color, -1)
          end
        end

        draw_tool if @tool
      end
    end

    def update
      @income  = 0
      @outcome = 0

      if @drag_start
        new_pos = CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y)
        offset = new_pos - @drag_start
        offset.x = normalize(offset.x) * @tile_size
        offset.y = normalize(offset.y) * @tile_size

        @offset = offset
      else

        direction = CyberarmEngine::Vector.new
        direction.x = -1 if Gosu.button_down?(Gosu::KbD)
        direction.x =  1 if Gosu.button_down?(Gosu::KbA)
        direction.y =  1 if Gosu.button_down?(Gosu::KbW)
        direction.y = -1 if Gosu.button_down?(Gosu::KbS)

        offset = @offset + (direction * @tile_size)
        offset.x = normalize(offset.x) * @tile_size
        offset.y = normalize(offset.y) * @tile_size
        @offset = offset
      end

      simulate

      if @tool
        use_tool if Gosu.button_down?(Gosu::MsLeft)
        if @tool == :other_demolish && Gosu.button_down?(Gosu::MsLeft)
          destroy_element(normalize(window.mouse_x - @offset.x), normalize(window.mouse_y - @offset.y))
        end
      end
    end

    def income
      @income - @outcome
    end

    def button_down(id)
      case id
      when Gosu::MsMiddle
        @drag_start = CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y) - @offset
      end
    end
    def button_up(id)
      case id
      when Gosu::MsMiddle
        @drag_start = nil
      end
    end

    def draw_tool
      x, y = normalize(window.mouse_x - @offset.x), normalize(window.mouse_y - @offset.y)

      tile = @grid.dig(x, y)
      return unless tile

      tool = Map::Tool.tools.dig(@tool)
      return unless tool

      rows = tool.rows
      columns = tool.columns

      columns.times do |_y|
        rows.times do |_x|
          gx = (@tile_size * x - ((rows/2.0).floor * @tile_size))    + _x * @tile_size
          gy = (@tile_size * y - ((columns/2.0).floor * @tile_size)) + _y * @tile_size

          _tile = @grid.dig(gx / @tile_size, gy / @tile_size)
          Gosu.draw_rect(
            gx, gy,
            @tile_size, @tile_size,
            _tile && _tile.available? ? tool.color : Gosu::Color::RED
          )
        end
      end
    end

    def use_tool
      x, y = normalize(window.mouse_x - @offset.x), normalize(window.mouse_y - @offset.y)

      tile = @grid.dig(x,y)
      return unless tile

      tool = Map::Tool.tools.dig(@tool)
      return unless tool

      return unless can_place_element?(tool, x, y)
      element = create_element(tool.places)
      @elements << element
      @outcome += tool.cost

      rows = tool.rows
      columns = tool.columns

      columns.times do |_y|
        rows.times do |_x|
          gx = (@tile_size * x - ((rows/2.0).floor * @tile_size))    + _x * @tile_size
          gy = (@tile_size * y - ((columns/2.0).floor * @tile_size)) + _y * @tile_size

          _tile = @grid.dig(gx / @tile_size, gy / @tile_size)
          _tile.send(:"#{tool.type}=", element)
        end
      end
    end

    def can_place_element?(tool, x, y)
      able = true

      rows = tool.rows
      columns = tool.columns

      columns.times do |_y|
        rows.times do |_x|
          gx = (@tile_size * x - ((rows/2.0).floor * @tile_size))    + _x * @tile_size
          gy = (@tile_size * y - ((columns/2.0).floor * @tile_size)) + _y * @tile_size

          _tile = @grid.dig(gx / @tile_size, gy / @tile_size)
          able = false if _tile.nil? || !_tile.available?
        end
      end

      return able
    end

    def create_element(places)
      case places
      when :zone_residential
        ResidentialZone.new(:zone_residential)
      when :zone_commercial
        CommercialZone.new(:zone_commercial)
      when :zone_industrial
        IndustrialZone.new(:zone_industrial)

      when :route_road
        RoadRoute.new(:route_road)
      when :route_powerline
        PowerLineRoute.new(:route_powerline)

      when :powerplant_coal
        PowerPlantCoalZone.new(:powerplant_coal)
      when :powerplant_solar
        PowerPlantSolarZone.new(:powerplant_solar)
      when :powerplant_nuclear
        PowerPlantNuclearZone.new(:powerplant_nuclear)

      when :service_fire_department
        FireDepartmentZone.new(:service_fire_department)
      when :service_police_department
        PoliceDepartmentZone.new(:service_police_department)
      when :service_city_park
        CityParkZone.new(:service_city_park)
      else
        raise "No such zone/route!"
      end
    end

    def destroy_element(x, y)
      _tile = @grid.dig(x, y)
      return unless _tile

      element = @elements.delete(_tile.element)
      return unless element

      @outcome += Map::Tool.tools.dig(element.type).cost * 0.1 # 10% of original cost
      grid_each do |tile, x, y|
        if tile.element == element
          tile.free
        end
      end
    end

    def normalize(n)
      (n / @tile_size.to_f).floor
    end

    def vary_color(color, jitter = 3)
      Gosu::Color.rgb(
        color.red   + rand(-jitter..jitter),
        color.green + rand(-jitter..jitter),
        color.blue  + rand(-jitter..jitter)
      )
    end

    def simulate
    end
  end
end