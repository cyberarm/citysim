module CitySim
  class Map
    class GameTime
      Timer = Struct.new(:repeats, :owner, :freq, :last_time, :action)

      attr_reader :start_time
      def initialize(map, time = Time.parse("#{Time.now.year}-01-01 00:00:00").to_f * 1000)
        @map = map

        @time = time
        @start_time = @time
        @last_time  = @time

        @timers = []

        @delta_time = (1000.0 / 60.0) / 1000.0 # 16.6667ms
        @accumulator = 0.0

        @base_unit = 1.0
      end

      def base_time
        Time.at(@time / 1000.0)
      end

      def second
        base_time.sec
      end

      def minute
        base_time.min
      end

      def hour
        base_time.hour
      end

      def day
        base_time.day
      end

      def month
        base_time.month
      end

      def year
        base_time.year
      end

      def time
        @time
      end

      def current_time
        base_time
      end

      def speed=(n)
        raise unless n.is_a?(Numeric)
        @base_unit = n
      end

      def step(delta, &block)
        @last_time = @time
        @time += (delta * 1000.0) * @base_unit

        # TODO: fire time passage event
        # fire_events
        # TODO: process timers
        simulation_time = (@time - @last_time).to_f / 1000.0
        if simulation_time > 0.25
          simulation_time = 0.25
        end
        @accumulator += simulation_time

        while(@accumulator >= delta)
          block.call
          check_timers

          @accumulator -= delta
        end
      end

      def check_timers
        @timers.each do |timer|
          if (@time - timer.last_time) >= timer.freq
            timer.action.call

            unless timer.repeats
              @timers.delete(timer)
            else
              timer.last_time = @time
            end
          end
        end
      end

      def every(owner, ms, &block)
        @timers << Timer.new(true, owner, ms, @time, block)
      end

      def after(owner, ms, &block)
        @timers << Timer.new(false, owner, ms, @time, block)
      end

      def removed(element)
        @timers.delete_if {|timer| timer.owner == element}
      end

      def delta
        @delta_time
      end
    end
  end
end