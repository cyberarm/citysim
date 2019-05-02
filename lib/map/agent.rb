module CitySim
  class Map
    class Agent
      def initialize(map:, goal:, &block)
        @map = map
        @goal = goal
        @block = block

        setup
      end

      def setup
      end

      def draw
      end

      def update
      end
    end
  end
end