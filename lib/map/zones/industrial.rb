module CitySim
  class Map
    class IndustrialZone < Zone
      def setup
        @needs = Data.new(5, 0, 5)

        add_tag(:needs_power)
        add_tag(:needs_workers)
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