module CitySim
  class Map
    module Store
      class Level
        include Save, Load

        def initialize(city_name, savefile)
          @savefile = savefile
          @savefile ||= "data/#{city_name}.save"
          @savefile ||= "data/unnamed_#{Time.now.strftime("%Y-%M-%d_%s")}.save"

          @store = Hash.new
          @store = JSON.parse(File.read(@savefile), symbolize_names: true) if savefile
        end

        def [](key)
          @store.dig(key)
        end

        def []=(key, value)
          @store[key] = value
        end
      end
    end
  end
end