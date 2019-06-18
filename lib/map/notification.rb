module CitySim
  class Map
    class Notification
      attr_accessor :type, :title, :messages, :icons, :visible
      def initialize(zone)
        @zone = zone

        @type = :message
        @title = ""
        @message = ""
        @icons = []

        @title_text   = CyberarmEngine::Text.new("", size: 28, color: Gosu::Color::BLACK, z: 6)
        @message_text = CyberarmEngine::Text.new("", size: 18, color: Gosu::Color::BLACK, z: 6)

        @padding = 10
        @visible = false

        @setup = false
      end

      def setup
        top_left = @zone.tiles.first.position * 1.0
        bottom_right = @zone.tiles.last.position * 1.0 + 1

        @center_point = ((bottom_right + top_left) * @zone.map.tile_size) / 2

        @setup = true
      end

      def draw
        setup unless @setup
        return unless @visible

        case @type
        when :message
          draw_message
        when :icons
          draw_icons
        when :message_with_icons
          draw_messsage_with_icons
        else
          raise "Unable to handle type: #{@type.inspect}"
        end
      end

      def draw_balloon(x, y, width, height)
        Gosu.draw_rect(x - 1, y - 1, width + 2, height + 2, Gosu::Color::GRAY, 5)
        Gosu.draw_rect(x, y, width, height, Gosu::Color::WHITE, 5)

        Gosu.draw_triangle(
          @center_point.x - @padding - 1, y + height,
          Gosu::Color::GRAY,
          @center_point.x + @padding + 1, y + height,
          Gosu::Color::GRAY,
          @center_point.x, y + height + @padding + 1,
          Gosu::Color::GRAY, 5
        )
        Gosu.draw_triangle(
          @center_point.x - @padding, y + height,
          Gosu::Color::WHITE,
          @center_point.x + @padding, y + height,
          Gosu::Color::WHITE,
          @center_point.x, y + height + @padding,
          Gosu::Color::WHITE, 5
        )
      end

      def draw_message
        @title_text.text = @title
        @message_text.text = @message

        widest  = @title_text.width > @message_text.width ? @title_text : @message_text

        width  = widest.width + (@padding * 2)
        height = @title_text.height + @message_text.height + (@padding * 3)

        @title_text.x = @center_point.x - (@title_text.width / 2)
        @title_text.y = @center_point.y - (height + @padding)

        @message_text.x = @center_point.x - (@message_text.width / 2)
        @message_text.y = @title_text.y + @title_text.height + @padding

        draw_balloon(
          @center_point.x - (widest.width / 2 + @padding), @center_point.y - (height + @padding * 2),
          width, height
        )

        @title_text.draw
        @message_text.draw
      end

      def draw_icons
      end

      def draw_messsage_with_icons
      end
    end
  end
end