module CitySim
  class Map
    class CommercialZone < Zone
      def setup
        @needs = Data.new(5, 0, 5, 5, 10)

        add_tag(:needs_workers)
        add_tag(:needs_shoppers)
        add_tag(:needs_goods)
        add_tag(:produces_money)
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