module CitySim
  class Map
    class FireDepartmentTool < Tool
      def places
        :service_fire_department
      end

      def color
        Gosu::Color.rgba(255, 0, 127, 150)
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