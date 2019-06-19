module CitySim
  class Map
    class PoliceDepartmentZone < Zone
      def setup
        add_tag(:needs_power)
        add_tag(:needs_workers)
        add_tag(:produces_squad_cars)

        @data[:max_power] = 5
        @data[:max_workers] = 20
        @data[:max_squad_cars] = 4
      end

      def color
        Tool::POLICE_DEPARTMENT_COLOR
      end

      def label
        "Police Dept."
      end
    end
  end
end