module CitySim
  class Map
    module Pathfinding
      class Pathfinder
        Node = Struct.new(:tile, :parent, :distance, :cost)
        def initialize(map, source, goal, travels_along = Route, allow_diagonal = false)
          @map = map
          @source = source
          @goal = goal
          @travels_along = travels_along
          @allow_diagonal = allow_diagonal

          @created_nodes = 0
          @nodes = []
          @path  = []
          @tiles = @map.tiles.clone

          @visited = Hash.new do |hash, value|
            hash[value] = Hash.new {|h, v| h[v] = false}
          end

          @depth = 0
          @max_depth = Float::INFINITY
          @seeking = true

          find
        end

        def find
          while(@seeking && @depth < @max_depth)
            seek
          end
        end

        def seek
          unless @current_node && reached_goal?
            @seeking = false
            return
          end

          @visited[x][y] = true

          @current_node = next_node
          @depth += 1
        end

        def node_visited?(node)
          @visited[node.tile.position.x][node.tile.position.y]
        end

        def add_node(node)
          return unless node
          return if node_visited?(node)

          @nodes << node
          return node
        end

        def create_node(x, y, parent = nil)
          node = Node.new
          node.tile = @map.grid[x][y]
          node.parent = parent
          node.distance = parent.distance + 1 if parent
          node.cost = 0

          @created_nodes += 1
          return node
        end

        def next_node
          fittest = nil
          fittest_distance = Float::INFINITY

          distance = nil
          @nodes.each do |node|
            next if node == @current_node

            distance = node.tile.position.distance(@goal.position)

            if distance < fittest_distance
              if fittest && (node.distance + node.cost) < (fittest.distance + fittest.cost)
                fittest = node
                fittest_distance = distance
              else
                fittest = node
                fittest_distance = distance
              end
            end
          end

          return fittest
        end
      end
    end
  end
end