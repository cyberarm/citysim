module CitySim
  class Window < CyberarmEngine::Engine
    def initialize(width: Gosu.available_width, height: Gosu.available_height, fullscreen: false, update_interval: 1000.0/60, resizable: true)
      super(width: width, height: height, fullscreen: fullscreen, update_interval: update_interval, resizable: resizable)
    end

    def setup
      @show_cursor = true
      push_state(CitySim::Menus::Main)
    end
  end
end
