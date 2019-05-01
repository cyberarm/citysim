module CitySim
  class Map
    include CyberarmEngine::Common

    attr_reader :money, :citizens, :elements, :tile_size, :grid
    def initialize(game:, rows: 33, columns: 33, tile_size: 64)
      @game = game
      @rows, @columns = rows, columns
      @tile_size = tile_size

      @money = 30_000
      @citizens = []
      @scroll_speed = 200

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
          @grid[x][y] = Tile.new(position: CyberarmEngine::Vector.new(x, y), type: Tile::LAND, color: vary_color(Tile::LAND_COLOR))
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
            @grid[x][y].draw(@tile_size)
          end
        end

        @elements.each(&:draw)

        tool.draw if tool
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
        direction.x =  1 if Gosu.button_down?(Gosu::KbA)
        direction.x = -1 if Gosu.button_down?(Gosu::KbD)

        direction.y =  1 if Gosu.button_down?(Gosu::KbW)
        direction.y = -1 if Gosu.button_down?(Gosu::KbS)

        scroll_speed = @scroll_speed
        if Gosu.button_down?(Gosu::KbLeftControl) || Gosu.button_down?(Gosu::KbRightControl)
          scroll_speed+= (@scroll_speed*2)
        end

        offset = @offset + direction.normalized * ((scroll_speed) * window.dt)
        @offset = offset
      end

      simulate

      if !@game.mouse_over_menu? && @tool
        use_tool if Gosu.button_down?(Gosu::MsLeft)
      end

      @money += income
    end

    def tool
      Map::Tool.tools.dig(@tool)
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
      when Gosu::KbEscape
        # pause_menu unless @tool
        @tool = nil if @tool
      end
    end

    def active_tile
      @grid.dig(grid_x,grid_y)
    end

    # Mouse position in grid coordinates
    def grid_x
      normalize(window.mouse_x - @offset.x)
    end

    # Mouse position in grid coordinates
    def grid_y
      normalize(window.mouse_y - @offset.y)
    end

    def use_tool
      return unless active_tile

      tool = Map::Tool.tools.dig(@tool)
      return unless tool
      return unless @money >= tool.cost

      return unless tool.can_use?(grid_x, grid_y)
      element = nil

      unless tool.type == :demolition
        element = create_element(tool.places, CyberarmEngine::Vector.new(grid_x, grid_y))
        @elements << element
      end

      charge(tool.cost)

      tool.use(grid_x, grid_y, element)
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

    def charge(cost)
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
        list[:left]  = search(position.x - 1, position.y, limit) if search(position.x - 1, position.y, limit)
        list[:right] = search(position.x + 1, position.y, limit) if search(position.x + 1, position.y, limit)
        list[:up]    = search(position.x, position.y - 1, limit) if search(position.x, position.y - 1, limit)
        list[:down]  = search(position.x, position.y + 1, limit) if search(position.x, position.y + 1, limit)

        if search == :eight_way
          list[:top_left]     = search(position.x - 1, position.y - 1, limit) if search(position.x - 1, position.y - 1, limit)
          list[:top_right]    = search(position.x + 1, position.y - 1, limit) if search(position.x + 1, position.y - 1, limit)
          list[:bottom_left]  = search(position.x - 1, position.y + 1, limit) if search(position.x - 1, position.y + 1, limit)
          list[:bottom_right] = search(position.x + 1, position.y + 1, limit) if search(position.x + 1, position.y + 1, limit)
        end
      else
        # search edges and return an Array for each side
      end

      return list
    end

    def search(x, y, limit)
      tile = @grid.dig(x, y)
      if tile && tile.element.is_a?(limit)
        tile
      else
        nil
      end
    end
  end
end