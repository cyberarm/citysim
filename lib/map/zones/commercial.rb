module CitySim
  class Map
    class CommercialZone < Zone
      def setup
        add_tag(:needs_workers)
        add_tag(:needs_shoppers)
        add_tag(:needs_goods)
        add_tag(:produces_money)

        @data[:max_power] = 5
        @data[:max_workers] = 15
        @data[:max_shoppers] = 25
        @data[:max_goods] = @data[:max_shoppers]
      end

      def color
        Tool::COMMERCIAL_COLOR
      end

      def label
        "Commercial"
      end
    end
  end
end