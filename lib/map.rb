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

    def position_map
      @offset.x = normalize(window.width/2 - width/2)
      @offset.y = normalize(window.height/2 - height/2)
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
        offset.x = normalize(offset.x)
        offset.y = normalize(offset.y)

        @offset = offset
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
      x, y = normalize(window.mouse_x), normalize(window.mouse_y)

      if x.between?(@offset.x, @offset.x + (@rows * @tile_size)) &&
         y.between?(@offset.y, @offset.y + (@columns * @tile_size))
        Gosu.draw_rect(x - @offset.x, y - @offset.y, @tile_size, @tile_size, tool_color)
      end
    end

    def tool_color
      Gosu::Color.rgba(100, 100, 150, 200)
    end

    def normalize(n)
      (n / @tile_size.to_f).floor * @tile_size
    end

    def vary_color(color, jitter = 5)
      Gosu::Color.rgb(
        color.red + rand(-jitter..jitter),
        color.green + rand(-jitter..jitter),
        color.blue + rand(-jitter..jitter)
      )
    end
  end
end