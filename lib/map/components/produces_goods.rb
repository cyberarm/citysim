module CitySim
  class Map
    class ProducesGoodsComponent < Component
      def identifier
        :produces_goods
      end

      def produce_goods_interval(element)
        1_000 # ms game time
        element.data[:produce_goods_interval]
      end

      def produce_goods_amount(element)
        element.data[:produce_goods_amount]
      end

      def max_goods_stored(element)
        element.data[:max_goods_stored]
      end

      def use(element)
        element.data[:goods] ||= 0
        element.data[:last_produced_goods_at] ||= 0

        if element.map.milliseconds >= element.data[:last_produced_goods_at] + produce_goods_interval(element)
          produce_goods(element)
          deliver_goods(element)

          element.data[:last_produced_goods_at] = element.map.milliseconds
        end
      end

      def produce_goods(element)
        element.data[:goods] += produce_goods_amount(element) if element.data[:workers] > 0 && element.data[:power] > 0
        element.data[:goods] = max_goods_stored(element) if element.data[:goods] > max_goods_stored(element)
      end

      def deliver_goods(element)
      end
    end
  end
end