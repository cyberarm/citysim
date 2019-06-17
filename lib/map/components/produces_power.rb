module CitySim
  class Map
    class ProducesPowerComponent < Component
      def identifier
        :produces_power
      end

      def produce_power_interval
        500 # ms game time
      end

      def use(element)
        element.data[:last_produced_power_at] ||= 0

        if element.map.milliseconds >= element.data[:last_produced_power_at] + produce_power_interval
          produce_power(element)
          deliver_power(element)

          element.data[:last_produced_power_at] = element.map.milliseconds
        end
      end

      def deliver_power(element)
        element.map.neighbors(element, :four_way, [:powerlinelike, :zonelike]).each do |key, value|
          # puts "  :#{key} -> #{value.map {|v| v.element.class}}"
        end
      end
    end
  end
end