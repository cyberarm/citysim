module CitySim
  class Setting
    def self.file_path
      "#{GAME_ROOT_PATH}/assets/settings.json"
    end

    def self.setup
      save_defaults unless File.exist?(Setting.file_path)
      @store = JSON.parse(File.read(Setting.file_path), symbolize_names: true)
    end

    def self.save_defaults
      hash = {
        default_map_name: "Centerville",
        default_map_width: 33,
        default_map_height: 33,

        debug_mode: false,
        debug_info_bar: false,
        debug_pathfinding: false,
      }

      File.open(Setting.file_path, "w") {|f| f.write(JSON.dump(hash))}
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

    def self.save!
      File.open(Setting.file_path, "w") {|f| f.write(JSON.dump(@store))}
    end
  end
end