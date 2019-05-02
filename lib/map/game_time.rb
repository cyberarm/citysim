module CitySim
  class Map
    class GameTime
      Timer = Struct.new(:repeats, :freq, :last_time, :action)

      attr_reader :start_time
      def initialize(map)
        @map = map

        @time = (Time.parse("#{Time.now.year}-01-01 00:00:00").to_f * 1000)
        @start_time = @time

        @timers = []

        @base_unit = 10.0
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
        base_time.strftime("%Y-%m-%d %H:%M:%S")
      end

      def step(delta)
        @time += (delta * 1000.0) * @base_unit

        # TODO: fire time passage event
        # fire_events
        # TODO: process timers
        check_timers
      end

      def check_timers
        @timers.each do |timer|
          if ((@time - timer.last_time) / @base_unit) > timer.freq
            timer.action.call

            unless timer.repeats
              @timers.delete(timer)
            else
              timer.last_time = @time
            end
          end
        end
      end

      def every(ms, &block)
        @timers << Timer.new(true, ms, @time, block)
      end

      def after(ms, &block)
        @timers << Timer.new(false, ms, @time, block)
      end
    end
  end
end