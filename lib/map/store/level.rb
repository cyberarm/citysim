module CitySim
  class Map
    module Store
      class Level
        include Save, Load

        def initialize(city_name, savefile)
          @savefile = savefile
          @savefile ||= "#{GAME_ROOT_PATH}/data/#{Level.safe_filename(city_name)}.save"
          @savefile ||= "#{GAME_ROOT_PATH}/data/unnamed_#{Time.now.strftime("%Y-%M-%d_%s")}.save"

          @store = Hash.new
          @store = JSON.parse(File.read(@savefile), symbolize_names: true) if savefile
        end

        def [](key)
          @store.dig(key)
        end

        def []=(key, value)
          @store[key] = value
        end

        def self.safe_filename(name)
          regex = /[~`!@#$%^&*()=+\-{}\[\]<>?|:;'",.\\ ]/
          name.to_s.downcase.gsub(regex, "_")
        end
      end
    end
  end
end
