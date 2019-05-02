module CitySim
  class Map
    class GameTime
      attr_reader :start_time
      def initialize
        @time = (Time.parse("#{Time.now.year}-01-01 00:00:00").to_f * 1000)
        @start_time = @time

        @base_unit = 1.0
      end

      def base_time
        Time.at(@time / 1000.0)
      end

      def second
        base_time.strftime("%S")
      end

      def minute
        base_time.strftime("%M")
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
        # "#{hour}:#{minute}:#{second} #{day}/#{month}/#{year}"
        base_time.strftime("%Y-%m-%d %H:%M:%S")
      end

      def step(delta)
        @time += delta * 1000.0

        # fire time passage event
      end
    end
  end
end