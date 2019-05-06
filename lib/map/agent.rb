module CitySim
  class Map
    class Agent
      include CyberarmEngine::Common
      include Pathfinding
      attr_reader :position
      def initialize(map:, position:)
        @map = map
        @position = position

        setup
      end

      def setup
      end

      def set_goal(element)
        @goal = element
        find_path(@position, @goal)
      end

      def remove
        @map.agents.delete(self)
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

      def at_goal?
      end

      def move_towards_goal
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