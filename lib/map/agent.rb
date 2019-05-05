module CitySim
  class Map
    class Agent
      include Pathfinding
      attr_reader :position
      def initialize(map:, position:, &block)
        @map = map
        @position = position
        @block = block

        setup
      end

      def setup
      end

      def goal=(element)
        @goal = element
        find_path(@goal)
      end

      def draw
      end

      def update
        unless at_goal?
          move_towards_goal
        else
          # do a thing
        end
      end

      def dump
        {
        }
      end

      def load(hash)
      end
    end
  end
end