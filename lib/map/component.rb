module CitySim
  class Map
    class Component
      def self.inherited(subclass)
        @list ||= []
        @list << subclass
      end

      def self.setup
        @list ||= []
        @components = []
        @list.each do |subclass|
          @components << subclass.new
        end
      end

      def self.use(element, component)
        if comp = @components.detect {|c| c.identifier == component}
          comp.use(element)
        else
          raise "No such component found! (:#{component})"
        end
      end

      def identifier
        raise NotImplementedError
      end

      def use(element)
        raise NotImplementedError
      end
    end
  end
end