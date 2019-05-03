module CitySim
  class Map
    module Store
      module Save
        def save
          File.open(@savefile, "w") do |file|
            file.write JSON.dump(@store)
          end
        end
      end
    end
  end
end