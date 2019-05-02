begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

require "time"

require_relative "lib/map"
require_relative "lib/map/tile"
require_relative "lib/map/game_time"
require_relative "lib/map/zone"
require_relative "lib/map/zones/residential"
require_relative "lib/map/zones/commercial"
require_relative "lib/map/zones/industrial"
require_relative "lib/map/zones/route"
require_relative "lib/map/zones/routes/road"
require_relative "lib/map/zones/routes/powerline"
require_relative "lib/map/zones/powerplant"
require_relative "lib/map/zones/powerplants/powerplant_coal"
require_relative "lib/map/zones/powerplants/powerplant_solar"
require_relative "lib/map/zones/powerplants/powerplant_nuclear"
require_relative "lib/map/zones/services/fire_department"
require_relative "lib/map/zones/services/police_department"
require_relative "lib/map/zones/services/city_park"

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
require_relative "lib/map/tools/demolish"

require_relative "lib/menus/main"
require_relative "lib/game"
require_relative "lib/window"

CitySim::Window.new.show
