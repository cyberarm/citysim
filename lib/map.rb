module CitySim
  class Map
    include CyberarmEngine::Common
    Tile = Struct.new(:type, :color)

    def initialize(rows:, columns:, tile_size: 16)
      @rows, @columns = rows, columns
      @tile_size = tile_size

      @tool = nil
      @grid = {}

      @drag_start = nil
      @drag_speed = 0.1
      @offset = CyberarmEngine::Vector.new

      @default_tile = :land
      @green = Gosu::Color.rgb(25, 150, 15)

      generate_map
      position_map
    end

    def generate_map
      @columns.times do |y|
        @rows.times do |x|
          @grid[x] ||= {}
          @grid[x][y] = Tile.new(@default_tile, vary_color(@green))
        end
      end
    end

    # Center map on screen
    def position_map
      @offset.x = normalize(window.width/2  - width/2)  * @tile_size
      @offset.y = normalize(window.height/2 - height/2) * @tile_size
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

      if @tool
        use_tool if Gosu.button_down?(Gosu::MsLeft)
      end
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

      if (@tile_size * x + @offset.x).between?(@offset.x, @offset.x + (@rows * @tile_size)) &&
         (@tile_size * y + @offset.y).between?(@offset.y, @offset.y + (@columns * @tile_size))
        tool = Map::Tool.tools.dig(@tool)
        return unless tool

        rows = tool.rows
        columns = tool.columns

        columns.times do |_y|
          rows.times do |_x|
            Gosu.draw_rect(
              (@tile_size * x - ((rows/2.0).floor * @tile_size))    + _x * @tile_size,
              (@tile_size * y - ((columns/2.0).floor * @tile_size)) + _y * @tile_size,
              @tile_size, @tile_size,
              tool_color
            )
          end
        end
      end
    end

    def use_tool
      x, y = normalize(window.mouse_x - @offset.x), normalize(window.mouse_y - @offset.y)

      tile = @grid.dig(x,y)
      return unless tile

      tile.color = Gosu::Color::BLACK
    end

    def tool_color
      Gosu::Color.rgba(100, 100, 150, 100)
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
  end
end