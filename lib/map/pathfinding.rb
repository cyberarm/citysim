module CitySim
  class Map
    module Pathfinding
      def find_path(source, goal, allow_diagonal = false)
        @pathfinder = Pathfinder.new(@map, source, @goal, travels_along, allow_diagonal)
      end

      def travels_along
        Route
      end
    end
  end
end