module CitySim
  class Map
    include CyberarmEngine::Common

    attr_reader :money, :citizens, :elements, :tile_size
    def initialize(game:, rows: 33, columns: 33, tile_size: 64)
      @game = game
      @rows, @columns = rows, columns
      @tile_size = tile_size

      @money = 30_000
      @citizens = []

      @tool = nil
      @grid = {}
      @elements = []

      @drag_start = nil
      @drag_speed = 0.1
      @offset = CyberarmEngine::Vector.new

      @income = 0
      @outcome= 0

      generate_map
      position_map
    end

    def generate_map
      @columns.times do |y|
        @rows.times do |x|
          @grid[x] ||= {}
          # @grid[x][y] = Tile.new(type: Tile::WATER, color: vary_color(Tile::WATER_COLOR))
          @grid[x][y] = Tile.new(type: Tile::LAND, color: vary_color(Tile::LAND_COLOR))
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
            @grid[x][y].draw(x, y, @tile_size)
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

      @money += income
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
      return unless @money >= tool.cost

      return unless can_place_element?(tool, x, y)
      element = create_element(tool.places, CyberarmEngine::Vector.new(x, y))
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

      element.align_with_neighbors if element.is_a?(RoadRoute)
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

    def create_element(places, position)
      case places
      when :zone_residential
        ResidentialZone.new(self, :zone_residential, position)
      when :zone_commercial
        CommercialZone.new(self, :zone_commercial, position)
      when :zone_industrial
        IndustrialZone.new(self, :zone_industrial, position)

      when :route_road
        RoadRoute.new(self, :route_road, position)
      when :route_powerline
        PowerLineRoute.new(self, :route_powerline, position)

      when :powerplant_coal
        PowerPlantCoalZone.new(self, :powerplant_coal, position)
      when :powerplant_solar
        PowerPlantSolarZone.new(self, :powerplant_solar, position)
      when :powerplant_nuclear
        PowerPlantNuclearZone.new(self, :powerplant_nuclear, position)

      when :service_fire_department
        FireDepartmentZone.new(self, :service_fire_department, position)
      when :service_police_department
        PoliceDepartmentZone.new(self, :service_police_department, position)
      when :service_city_park
        CityParkZone.new(self, :service_city_park, position)
      else
        raise "No such zone/route!"
      end
    end

    def destroy_element(x, y)
      _tile = @grid.dig(x, y)
      return unless _tile
      return unless _tile.element

      cost = Map::Tool.tools.dig(_tile.element.type).cost * 0.1 # 10% of original cost
      return unless @money >= cost


      element = @elements.delete(_tile.element)
      grid_each do |tile, x, y|
        if tile.element == element
          tile.free
        end
      end

      @outcome += cost
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
      @elements.each do |e|
        e.update
      end
    end

    def neighbors(element, search = :eight_way, limit = Zone)
      # :four_way - Get all elements along edges
      # :eight_way - Get all elements bordering element

      list = {}

      tool = Map::Tool.tools.dig(element.type)
      position = element.position
      if tool.rows * tool.columns == 1
        # search immediate neighbors only
        list[:left]  = @grid[position.x - 1][position.y] if @grid[position.x - 1][position.y].element.is_a?(limit)
        list[:right] = @grid[position.x + 1][position.y] if @grid[position.x + 1][position.y].element.is_a?(limit)
        list[:up]    = @grid[position.x][position.y - 1] if @grid[position.x][position.y - 1].element.is_a?(limit)
        list[:down]  = @grid[position.x][position.y + 1] if @grid[position.x][position.y + 1].element.is_a?(limit)

        if search == :eight_way
          list[:top_left]     = @grid[position.x - 1][position.y - 1] if @grid[position.x - 1][position.y - 1].element.is_a?(limit)
          list[:top_right]    = @grid[position.x + 1][position.y - 1] if @grid[position.x + 1][position.y - 1].element.is_a?(limit)
          list[:bottom_left]  = @grid[position.x - 1][position.y + 1] if @grid[position.x - 1][position.y + 1].element.is_a?(limit)
          list[:bottom_right] = @grid[position.x + 1][position.y + 1] if @grid[position.x + 1][position.y + 1].element.is_a?(limit)
        end
      else
        # search edges and return an Array for each side
      end

      return list
    end
  end
end