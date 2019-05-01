module CitySim
  class Map
    class PoliceDepartmentZone < Zone
      def color
        Tool::POLICE_DEPARTMENT_COLOR
      end

      def label
        "Police Dept."
      end
    end
  end
end