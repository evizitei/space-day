require 'gosu'

require_relative './lib/dodge_area'

class SpaceDay < Gosu::Window
  GAME_WIDTH = 1000
  GAME_HEIGHT = 720

  def initialize
    super GAME_WIDTH, GAME_HEIGHT
    self.caption = "Space Day!"
    @background_image = Gosu::Image.new("assets/background.jpg", tileable: true)
    @dodge_area = DodgeArea.new({w: GAME_WIDTH, h: GAME_HEIGHT})
  end

  def update
    current_tick = Gosu.milliseconds
    @dodge_area.tick
  end

  def draw
    @background_image.draw(0,0,0)
    @dodge_area.draw()
  end
end

SpaceDay.new.show
