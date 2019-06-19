module CitySim
  class Map
    class ConsumesPowerComponent < Component
      def identifier
        :consumes_power
      end

      def use(element)
        element.data[:power] ||= 0
        element.data[:last_consumed_power_at] ||= 0
        element.data[:consume_power_interval] ||= 1_000 # ms in game

        if element.map.milliseconds >= element.data[:last_consumed_power_at] + element.data[:consume_power_interval]
          element.data[:power] -= 1 if element.data[:power] > 0

          element.data[:last_consumed_power_at] = element.map.milliseconds
        end
      end
    end
  end
end