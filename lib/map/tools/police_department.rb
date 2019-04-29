module CitySim
  class Map
    class PoliceDepartmentTool < Tool
      def places
        :service_police_department
      end

      def color
        Tool::POLICE_DEPARTMENT_COLOR
      end

      def cost
        Tool::POLICE_DEPARTMENT_COST
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