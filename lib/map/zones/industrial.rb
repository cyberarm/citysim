module CitySim
  class Map
    class IndustrialZone < Zone
      def setup
        add_tag(:receives_workers)
        add_tag(:produces_goods)
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