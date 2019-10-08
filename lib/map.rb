module CitySim
  class Map
    include CyberarmEngine::Common

    attr_reader :money, :tiles, :elements, :agents, :tile_size, :half_tile_size, :grid, :city_name
    attr_reader :rows, :columns, :scale
    def initialize(game:, rows: 33, columns: 33, tile_size: 64, savefile: nil)
      Map::Tool.reset
      Map::Tool.tools(self) # setup tools

      Map::Component.setup

      @game = game
      @rows, @columns = rows, columns
      @tile_size = tile_size
      @half_tile_size = @tile_size / 2
      @city_name = @game.options[:map_name] if @game.options[:map_name]

      @level = Store::Level.new(@city_name, savefile)
      @rows = @game.options[:map_rows] if @game.options[:map_rows]
      @columns = @game.options[:map_columns] if @game.options[:map_columns]

      @money = 30_000
      @scroll_speed = 400

      @game_time = GameTime.new(self)

      @tool = nil
      @grid = {}
      @tiles = []
      @elements = []
      @agents = []

      @drag_start = nil
      @drag_speed = 0.1
      @offset = CyberarmEngine::Vector.new

      @scale  = 1.0
      @old_scale = @scale
      @min_scale, @max_scale = 0.25, 4.0
      @scale_step = 0.25

      @income = 0
      @outcome= 0

      generate_map

      load_level if savefile
      center_map
    end

    def store
      @level
    end

    def generate_map
      @columns.times do |y|
        @rows.times do |x|
          @grid[x] ||= {}
          # @grid[x][y] = Tile.new(type: Tile::WATER, color: vary_color(Tile::WATER_COLOR))
          tile = Tile.new(position: CyberarmEngine::Vector.new(x, y), type: Tile::LAND, color: vary_color(Tile::LAND_COLOR))
          @tiles << tile
          @grid[x][y] = tile
        end
      end
    end

    # Center map on screen
    def center_map
      @offset.x = normalize(center.x - width  / 2) * @tile_size
      @offset.y = normalize(center.y - height / 2) * @tile_size
    end

    def load_level
      @city_name = store[:Map_city_name]
      @money     = store[:Map_money]
      @rows      = store[:Map_rows]
      @columns   = store[:Map_columns]
      @tile_size = store[:Map_tile_size]
      @game_time = GameTime.new(self, store[:Map_time])

      @tiles.clear
      store[:Map_tiles].each do |tile|
        x, y = tile[:position][:x], tile[:position][:y]

        _tile = Tile.new(
          position: CyberarmEngine::Vector.new(x, y),
          type: tile[:type],
          color: Gosu::Color.new(tile[:color].to_i(16))
        )

        @grid[x][y] = _tile
        @tiles << _tile
      end

      @elements.clear
      store[:Map_elements].each do |element|
        @tool = element[:type].to_sym

        if _element = use_tool(true, element[:position][:x], element[:position][:y])
          _element.load(element)
          _element.align_with_neighbors if _element.respond_to?(:align_with_neighbors)
        else
          raise "Failed to load element[:#{element[:type]}]"
        end
      end
      @tool = nil

      @agents.clear
      store[:Map_agents].each do |agent|
      end
    end

    def save_level
      store[:Map_city_name] = @city_name
      store[:Map_money] = @money
      store[:Map_rows] = @rows
      store[:Map_columns] = @columns
      store[:Map_tile_size] = @tile_size
      store[:Map_time] = @game_time.time

      store[:Map_elements] = sorted_elements.map(&:dump)
      store[:Map_agents] = @agents.map(&:dump)
      store[:Map_tiles] = @tiles.map(&:dump)
      @level.save
    end

    # returns list of Elements with Zones before Routes
    def sorted_elements
      list = []
      list << @elements.select {|e| e.is_a?(Zone)}
      list << @elements.select {|e| e.is_a?(Route)}

      list.flatten
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
      Gosu.scale(@scale, @scale, center.x, center.y) do
        Gosu.translate(@offset.x, @offset.y) do
          @map_tiles ||= Gosu.record(@rows * @tile_size, @columns * @tile_size) do
            @columns.times do |y|
              @rows.times do |x|
                @grid[x][y].draw(@tile_size)
              end
            end
          end

          @map_tiles.draw(0, 0, -1)
          @elements.each(&:draw)
          @agents.each(&:draw)

          tool.draw if tool
        end
      end
    end

    def update
      @income  = 0
      @outcome = 0

      if @drag_start
        new_pos = CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y)
        @offset = new_pos - @drag_start
      else

        direction = CyberarmEngine::Vector.new
        direction.x =  1 if Gosu.button_down?(Gosu::KbA) || Gosu.button_down?(Gosu::KbLeft)
        direction.x = -1 if Gosu.button_down?(Gosu::KbD) || Gosu.button_down?(Gosu::KbRight)

        direction.y =  1 if Gosu.button_down?(Gosu::KbW) || Gosu.button_down?(Gosu::KbUp)
        direction.y = -1 if Gosu.button_down?(Gosu::KbS) || Gosu.button_down?(Gosu::KbDown)

        scroll_speed = @scroll_speed
        if Gosu.button_down?(Gosu::KbLeftControl) || Gosu.button_down?(Gosu::KbRightControl)
          scroll_speed+= (@scroll_speed*2)
        end

        offset = @offset + direction.normalized * ((scroll_speed) * window.dt)
        @offset = offset
      end

      if !@game.mouse_over_menu? && @tool
        use_tool if Gosu.button_down?(Gosu::MsLeft)
      end

      @money += income
      @game_time.step(window.dt) do
        simulate
      end
    end

    def simulate
      @elements.each(&:update)
      @agents.each(&:update)
    end

    def tool
      Map::Tool.tools.dig(@tool)
    end

    def income
      @income - @outcome
    end

    def current_time
      @game_time.current_time
    end

    def button_down(id)
      case id
      when Gosu::MsMiddle
        @drag_start = CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y) - @offset
      when Gosu::KbSpace
        center_map
      end
    end
    def button_up(id)
      case id
      when Gosu::MsMiddle
        @drag_start = nil
      when Gosu::KbEscape
        @game.push_state(Menus::PauseGame.new(map: self)) unless @tool
        @tool = nil if @tool
      when Gosu::MsWheelDown
        @scale -= @scale_step

        if @scale < @min_scale
          @scale = @min_scale
        else
          @old_scale = @scale + @scale_step
          zoom_map
        end
      when Gosu::MsWheelUp
        @scale += @scale_step

        if @scale > @max_scale
          @scale = @max_scale
        else
          @old_scale = @scale - @scale_step
          zoom_map
        end
      end
    end

    def zoom_map
      # Based on: https://gamedev.stackexchange.com/a/9344
      @offset.x = @offset.x - (window.mouse_x / window.width  * ((window.width  / (@tile_size * @scale)) - @rows))
      @offset.y = @offset.y - (window.mouse_y / window.height * ((window.height / (@tile_size * @scale)) - @columns))
    end

    def active_tile
      @grid.dig(grid_x, grid_y)
    end

    # Mouse position in grid coordinates
    def grid_x
      (normalize_zoom(CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y)).x / @tile_size).floor
    end

    # Mouse position in grid coordinates
    def grid_y
      (normalize_zoom(CyberarmEngine::Vector.new(window.mouse_x, window.mouse_y)).y / @tile_size).floor
    end

    def normalize(n)
      (n / @tile_size.to_f).floor
    end

    def normalize_zoom(vector)
      neg_center = CyberarmEngine::Vector.new(-center.x, -center.y)

      scaled_position = (vector) / @scale
      scaled_translation = (neg_center / @scale + center)

      inverse = (scaled_position + scaled_translation) - @offset

      inverse.x = inverse.x.floor
      inverse.y = inverse.y.floor

      return inverse
    end

    def center
      CyberarmEngine::Vector.new(window.width / 2, window.height / 2)
    end

    def use_tool(unbound = false, x = grid_x, y = grid_y)
      return false unless unbound || active_tile

      tool = Map::Tool.tools.dig(@tool)
      return false unless tool
      return false unless unbound || @money >= tool.cost

      return false unless tool.can_use?(x, y)

      charge(tool.cost) unless unbound

      unless tool.type == :demolition
        tool.use(x, y, create_element(tool.places, CyberarmEngine::Vector.new(x, y)))
      else
        tool.use(x, y, nil)
      end

      return @elements.last
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
      when :route_road_and_powerline
        @tool = :route_road
        use_tool(true, position.x, position.y)
        @tool = :route_powerline
        use_tool(true, position.x, position.y)
        nil

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

    def vary_color(color, jitter = 3)
      Gosu::Color.rgb(
        color.red   + rand(-jitter..jitter),
        color.green + rand(-jitter..jitter),
        color.blue  + rand(-jitter..jitter)
      )
    end

    def neighbors(element, search = :eight_way, limit = :zonelike)
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
        list[:left], list[:right], list[:up], list[:down] = [], [], [], []
        # LEFT SIDE
        _x = normalize(element.box.min.x) - 1
        _y = normalize(element.box.min.y)
        tool.columns.times do |y|
          list[:left] << search(_x, _y + y, limit) if search(_x, _y + y, limit)
        end

        # RIGHT SIDE
        _x = normalize(element.box.max.x)
        _y = normalize(element.box.min.y)
        tool.columns.times do |y|
          list[:right] << search(_x, _y + y, limit) if search(_x, _y + y, limit)
        end

        # UP SIDE
        _x = normalize(element.box.min.x)
        _y = normalize(element.box.min.y) - 1
        tool.rows.times do |x|
          list[:up] << search(_x + x, _y, limit) if search(_x + x, _y, limit)
        end

        # DOWN SIDE
        _x = normalize(element.box.min.x)
        _y = normalize(element.box.max.y)
        tool.rows.times do |x|
          list[:down] << search(_x + x, _y, limit) if search(_x + x, _y, limit)
        end
      end

      return list
    end

    def search(x, y, limit)
      limit = [limit] unless limit.is_a?(Array)

      tile = @grid.dig(x, y)
      if tile && tile.element && tile.element.tags.detect { |tag| limit.include?(tag) }
        tile
      else
        nil
      end
    end

    def every(owner, ms, &block)
      @game_time.every(owner, ms, &block)
    end

    def after(owner, ms, &block)
      @game_time.after(owner, ms, &block)
    end

    def removed(element)
      @game_time.removed(element)
    end

    # FIXED delta time for simulation
    def delta
      @game_time.delta
    end

    def milliseconds
      @game_time.base_time.to_f * 1000.0
    end

    def speed=(n)
      @game_time.speed=n
    end
  end
end
