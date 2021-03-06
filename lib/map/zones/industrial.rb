module CitySim
  class Map
    class IndustrialZone < Zone
      def setup
        add_tag(:needs_power)
        add_tag(:needs_workers)
        add_tag(:produces_goods)

        @data[:max_power] = 5
        @data[:max_workers] = 20
        @data[:max_goods] = 25

        @data[:produce_goods_interval] = 1_000
        @data[:produce_goods_amount] = 2
        @data[:max_goods_stored] = @data[:max_goods]
      end

      def color
        Tool::INDUSTRIAL_COLOR
      end

      def label
        "Industrial"
      end
    end
  end
end