module CitySim
  class Map
    class CommercialZone < Zone
      def color
        Tool::COMMERCIAL_COLOR
      end

      def label
        "Commercial"
      end
    end
  end
end