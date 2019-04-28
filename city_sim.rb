begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

require_relative "lib/map"
#require_relative "lib/map/grid"
#require_relative "lib/zone"
require_relative "lib/menus/main"
require_relative "lib/game"
require_relative "lib/window"

CitySim::Window.new.show
