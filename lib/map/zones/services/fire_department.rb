module CitySim
  class Map
    class FireDepartmentZone < Zone
      def color
        Tool::FIRE_DEPARTMENT_COLOR
      end

      def label
        "Fire Dept."
      end
    end
  end
end