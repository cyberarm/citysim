begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

require_relative "lib/map"
require_relative "lib/map/tile"
require_relative "lib/map/zone"
require_relative "lib/map/zones/residential"

require_relative "lib/map/tool"
require_relative "lib/map/tools/residential"
require_relative "lib/map/tools/commercial"
require_relative "lib/map/tools/industrial"
require_relative "lib/map/tools/road"
require_relative "lib/map/tools/powerline"
require_relative "lib/map/tools/powerplant_coal"
require_relative "lib/map/tools/powerplant_solar"
require_relative "lib/map/tools/powerplant_nuclear"
require_relative "lib/map/tools/fire_department"
require_relative "lib/map/tools/police_department"
require_relative "lib/map/tools/city_park"

require_relative "lib/menus/main"
require_relative "lib/game"
require_relative "lib/window"

CitySim::Window.new.show
