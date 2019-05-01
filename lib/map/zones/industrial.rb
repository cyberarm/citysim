module CitySim
  class Map
    class IndustrialZone < Zone
      def color
        Tool::INDUSTRIAL_COLOR
      end

      def label
        "Industrial"
      end
    end
  end
end