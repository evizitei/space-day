require 'gosu'

require_relative './lib/dodge_area'
require_relative './lib/lander_scene'

class SpaceDay < Gosu::Window
  GAME_WIDTH = 1000
  GAME_HEIGHT = 720

  def initialize
    super GAME_WIDTH, GAME_HEIGHT
    self.caption = "Space Day!"
    @dodge_area = DodgeArea.new({w: GAME_WIDTH, h: GAME_HEIGHT})
    @lander_scene = LanderScene.new({w: GAME_WIDTH, h: GAME_HEIGHT})
    @planetfall = false
  end

  def update
    current_tick = Gosu.milliseconds
    if @planetfall
      @lander_scene.tick
    else
      @dodge_area.tick
    end
    @planetfall = @dodge_area.planetfall?
  end

  def draw
    if @planetfall
      @lander_scene.draw()
    else
      @dodge_area.draw()
    end
  end
end

SpaceDay.new.show
