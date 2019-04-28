module CitySim
  class Map
    class FireDepartmentTool < Tool
      def places
        :service_fire_department
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