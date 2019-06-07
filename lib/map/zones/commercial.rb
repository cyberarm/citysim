module CitySim
  class Map
    class CommercialZone < Zone
      def setup
        add_tag(:receives_workers)
        add_tag(:receives_shoppers)
        add_tag(:receives_goods)
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