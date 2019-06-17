module CitySim
  class Map
    class Zone < Element
      attr_reader :data, :needs

      def initialize(map, type, position)
        add_tag(:zonelike)
        super
      end

      def update
        handle_wants_and_needs
      end

      def handle_wants_and_needs
        component(:consumes_power) if has_tag?(:needs_power)
        component(:consumes_goods) if has_tag?(:needs_goods)

        component(:produces_power) if has_tag?(:produces_power)
        component(:produces_goods) if has_tag?(:produces_goods)
      end

      def component(component)
        Component.use(self, component)
      end

      def create_agent(agent, route, goal, options = {})
        @map.agents << agent.new(map: @map, position: route.position, goal: goal, options: options)
      end

      def nearest_route(route)
        neighbors = @map.neighbors(self, :eight_way, route)
        neighbors.values.flatten.select{|v| v.element.has_tag?(route)}.sample
      end

      def send_packet(type, origin, target, options)
        create_agent(Packet, origin, target, options)
      end

      def handle_packet(packet)
        packet_data = packet.options
        case packet_data[:type]
        when :worker_request
        when :shopper_request
        when :resident_request
        when :power_request
        when :goods_request
        end
      end

      def debug_draw
        @debug_colors ||= {
          :left  => Gosu::Color.rgba(0, 255, 0, 200),
          :right => Gosu::Color.rgba(0, 0, 255, 200),
          :up    => Gosu::Color.rgba(255, 255, 255, 200),
          :down  => Gosu::Color.rgba(255, 0, 0, 200)
        }
        @map.neighbors(self, :eight_way, :roadlike).each do |side, list|
          list.each do |tile|
            Gosu.draw_rect(tile.position.x * @map.tile_size, tile.position.y * @map.tile_size, @map.tile_size, @map.tile_size, @debug_colors[side], 10)
          end
        end
      end
    end
  end
end