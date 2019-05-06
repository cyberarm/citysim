module CitySim
  class Map
    module Pathfinding
      class Pathfinder
        Node = Struct.new(:tile, :parent, :distance, :cost)
        attr_reader :path
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
          @max_depth = @map.rows > @map.columns ? @map.rows * 4 : @map.columns * 4
          @seeking = true

          @current_node = add_node create_node(source.x, source.y)
          @current_node.distance = 0
          @current_node.cost = 0

          find
        end

        def find
          while(@seeking && @depth < @max_depth)
            seek
          end

          # puts "Failed to find path to #{@goal.class.ancestors.first} -> #{@goal.position.x}:#{@goal.position.y} from: #{@source.x}:#{@source.y}" if @depth >= @max_depth
        end

        def at_goal?
          @current_node.tile.position.distance(@goal.position) < 1.1
        end

        def seek
          unless @current_node && @map.grid.dig(@goal.position.x, @goal.position.y)
            @seeking = false
            return
          end

          @visited[@current_node.tile.position.x][@current_node.tile.position.y] = true

          if at_goal?
            until(@current_node.parent.nil?)
              @path << @current_node
              @current_node = @current_node.parent
            end
            @path.reverse!

            @seeking = false
            # puts "Generated path with #{@path.size} steps, #{@created_nodes} nodes created."
            return
          end

          #LEFT
          add_node create_node(@current_node.tile.position.x - 1, @current_node.tile.position.y, @current_node)
          # RIGHT
          add_node create_node(@current_node.tile.position.x + 1, @current_node.tile.position.y, @current_node)
          # UP
          add_node create_node(@current_node.tile.position.x, @current_node.tile.position.y - 1, @current_node)
          # DOWN
          add_node create_node(@current_node.tile.position.x, @current_node.tile.position.y + 1, @current_node)

          # TODO: Add diagonal nodes, if requested

          @last_size = @nodes.size
          @current_node = next_node
          @depth += 1
        end

        def node_visited?(node)
          @visited[node.tile.position.x][node.tile.position.y]
        end

        def add_node(node)
          return unless node

          @nodes << node
          return node
        end

        def create_node(x, y, parent = nil)
          return unless tile = @map.grid.dig(x, y)
          return unless tile.element.is_a?(@travels_along) # Enabling this causes infinite loops...
          return if @visited.dig(x, y)
          return if @nodes.detect {|node| node.tile.position.x == x && node.tile.position.y == y}

          node = Node.new
          node.tile = tile
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