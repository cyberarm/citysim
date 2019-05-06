module CitySim
  class Setting
    def self.setup
      save_defaults unless File.exist?("assets/settings.json")
      @store = JSON.parse(File.read("assets/settings.json"), symbolize_names: true)
    end

    def self.save_defaults
      hash = {
        debug_mode: false,
      }

      File.open("assets/settings.json", "w") {|f| f.write(JSON.dump(hash))}
    end

    def self.enabled?(key)
      @store.dig(key)
    end

    def self.disabled?(key)
      @store.dig(key)
    end

    def self.set(key, value)
      @store[key]=value
    end

    def self.get(key)
      @store.dig(key)
    end
  end
end