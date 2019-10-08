module CitySim
  class Map
    class ProducesPowerComponent < Component
      def identifier
        :produces_power
      end

      def produce_power_interval(element)
        1_000 # ms game time
        element.data[:produce_power_interval]
      end

      def produce_power_amount(element)
        element.data[:produce_power_amount]
      end

      def max_power_stored(element)
        element.data[:max_power_stored]
      end

      def use(element)
        element.data[:power] ||= 0
        element.data[:last_produced_power_at] ||= 0

        if element.map.milliseconds >= element.data[:last_produced_power_at] + produce_power_interval(element)
          produce_power(element)
          deliver_power(element)

          element.data[:last_produced_power_at] = element.map.milliseconds
        end
      end

      def produce_power(element)
        element.data[:power] += produce_power_amount(element)
        element.data[:power] = max_power_stored(element) if element.data[:power] > max_power_stored(element)
      end

      def network_valid?(element)
        element.runtime_data[:connected_power_network] && !element.runtime_data[:power_network_changed]
      end

      def find_connected(element)
        return element.runtime_data[:connected_power_network] if network_valid?(element)

        visited = []
        pending = [element]

        while(search = pending.shift)
          search.map.neighbors(search, :four_way, [:powerlinelike, :zonelike]).each do |key, value|
            value = [value] unless value.is_a?(Array)

            value.each do |e|
              pending << e.element if e.element && !pending.include?(e.element) && !visited.include?(e.element)
            end
          end

          visited << search
        end

        element.runtime_data[:power_network_changed] = false
        return element.runtime_data[:connected_power_network] = visited
      end

      def deliver_power(element)
        return unless element.data[:power] > 0

        clients = find_connected(element)

        clients.each_with_index do |client, i|
          break unless element.data[:power] > 0

          # Skip to next client if client if maxed out on power storage
          next unless client.data[:power] < client.data[:max_power]
          # Pass power along if this client is supplied
          # next_client = clients[i + 1]
          # client_has_sufficient_supply = client.data[:power] > client.data[:max_power] / 2
          # next_client_needs_supply = (next_client && next_client.data[:power] > next_client.data[:max_power] / 2)
          # next if client_has_sufficient_supply && next_client_needs_supply

          element.data[:power] -= 1
          client.data[:power] += 1
        end
      end
    end
  end
end