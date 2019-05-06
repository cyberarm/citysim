module CitySim
  class Map
    module Pathfinding
      def find_path(source, goal, allow_diagonal = false)
        if Pathfinder.cached_path(source, goal, travels_along)
          puts "using a cached path!" if Setting.enabled?(:debug_mode)
          return @pathfinder = Pathfinder.cached_path(source, goal, travels_along)
        end
        @pathfinder = Pathfinder.new(@map, source, goal, travels_along, allow_diagonal)
      end

      def travels_along
        Route
      end
    end
  end
end