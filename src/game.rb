require 'gosu'

require_relative './lib/dodge_area'
require_relative './lib/lander_scene'
require_relative './lib/alien_invasion'
require_relative './lib/asteroid_belt'
require_relative './lib/black_holes'

class SpaceDay < Gosu::Window
  GAME_WIDTH = 1000
  GAME_HEIGHT = 720

  def initialize
    super GAME_WIDTH, GAME_HEIGHT
    @dim = {w: GAME_WIDTH, h: GAME_HEIGHT}
    self.caption = "Space Day!"
    @levels = [
      DodgeArea.new(@dim),
      LanderScene.new(@dim, background: 0),
      AlienInvasion.new(@dim),
      LanderScene.new(@dim, background: 1),
      AsteroidBelt.new(@dim),
      LanderScene.new(@dim, background: 2),
      BlackHoles.new(@dim),
      LanderScene.new(@dim, background: 3)
    ]
    @level_idx = -1
    next_level
  end

  def next_level
    @level_idx += 1
    @cur_scene = @levels[@level_idx]
  end

  def update
    if @cur_scene.done?
      next_level
    end
    @cur_scene.tick
  end

  def draw
    @cur_scene.draw
  end
end

SpaceDay.new.show
