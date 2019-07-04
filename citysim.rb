begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

require "time"
require "json"

require_relative "lib/version"
require_relative "lib/ext/gosu_color"
require_relative "lib/setting"
require_relative "lib/taggable"

require_relative "lib/map"
require_relative "lib/map/tile"
require_relative "lib/map/game_time"
require_relative "lib/map/element"
require_relative "lib/map/notification"

require_relative "lib/map/store/load"
require_relative "lib/map/store/save"
require_relative "lib/map/store/level"

require_relative "lib/map/route"
require_relative "lib/map/routes/road"
require_relative "lib/map/routes/powerline"
require_relative "lib/map/routes/road_and_powerline"

require_relative "lib/map/zone"
require_relative "lib/map/zones/residential"
require_relative "lib/map/zones/commercial"
require_relative "lib/map/zones/industrial"
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
require_relative "lib/map/tools/road_and_powerline"
require_relative "lib/map/tools/powerplant_coal"
require_relative "lib/map/tools/powerplant_solar"
require_relative "lib/map/tools/powerplant_nuclear"
require_relative "lib/map/tools/fire_department"
require_relative "lib/map/tools/police_department"
require_relative "lib/map/tools/city_park"
require_relative "lib/map/tools/demolish"

require_relative "lib/map/component"
require_relative "lib/map/components/consumes_power"
require_relative "lib/map/components/consumes_goods"
require_relative "lib/map/components/produces_power"
require_relative "lib/map/components/produces_goods"
# require_relative "lib/map/components/produces_money"
# require_relative "lib/map/components/produces_residents"

require_relative "lib/map/pathfinding"
require_relative "lib/map/pathfinding/pathfinder"

require_relative "lib/map/agent"
require_relative "lib/map/agents/vehicle"
require_relative "lib/map/agents/packet"

require_relative "lib/menus/main"
require_relative "lib/menus/new_game"
require_relative "lib/menus/load_game"
require_relative "lib/menus/pause_game"
require_relative "lib/menus/settings"
require_relative "lib/game"
require_relative "lib/window"

GAME_ROOT_PATH = File.expand_path(File.dirname(__FILE__))

CitySim::Window.new.show
