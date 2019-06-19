module CitySim
  class Map
    class FireDepartmentZone < Zone
      def setup
        add_tag(:needs_power)
        add_tag(:needs_workers)
        add_tag(:produces_fire_engines)

        @data[:max_power] = 5
        @data[:max_workers] = 20
        @data[:max_fire_engines] = 4
      end

      def color
        Tool::FIRE_DEPARTMENT_COLOR
      end

      def label
        "Fire Dept."
      end
    end
  end
end