module CitySim
  class Map
    class Agent
      include CyberarmEngine::Common
      include CitySim::Taggable
      include CitySim::Map::Pathfinding

      attr_reader :position
      def initialize(map:, position:, goal:)
        add_tag(:agentlike)

        @map = map
        @position = position
        set_goal(goal) if goal

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

      def debug_draw
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