module CitySim
  module Pathfinding
    def find_path(goal, allow_diagonal = false)
      @path = Pathfinder.new(@map, source, @goal, travels_along, allow_diagonal)
    end

    def travels_along
      Route
    end
  end
end