module CitySim
  class Map
    class PoliceDepartmentTool < Tool
      def places
        :service_police_department
      end

      def color
        Gosu::Color.rgba(255, 127, 127, 150)
      end

      def rows
        3
      end

      def columns
        3
      end
    end
  end
end