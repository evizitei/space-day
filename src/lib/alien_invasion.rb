require 'securerandom'
require_relative './fly_level'

class AlienInvasion < FlyLevel
  def initialize(dim)
    super(dim)
    @background_image = Gosu::Image.new("assets/level2/background.jpg", tileable: true)
    @planet_image = Gosu::Image.new("assets/level2/planet.png")
    @alien_image = Gosu::Image.new("assets/level2/alien_ship.png")
    reset_level!
  end

  def reset_level!
    super
    @aliens = [
      { x: 100 , y: 100, rot: 0 },
      { x: 500 , y: 200, rot: 0 },
      { x: 800 , y: 360, rot: 0 }
    ]
  end

  def random_init
    x_seed = SecureRandom.rand
    y_seed = SecureRandom.rand
    rot_seed = SecureRandom.rand
    xs_seed = SecureRandom.rand
    ys_seed = SecureRandom.rand
    {
      x: x_seed * @dim[:w],
      y: y_seed * @dim[:h],
      rot: rot_seed * 360,
      x_speed: (xs_seed * 6) - 3,
      y_speed: (ys_seed * 6) - 3
    }
  end

  def collided?(pos1, pos2)
    distance = Math.sqrt(((pos1[:x] - pos2[:x])**2) + ((pos1[:y]-pos2[:y])**2))
    return distance < 50
  end

  def tick
    move_ship
  end

  def draw_planet
    x = 800
    y = 1
    z = 2
    scale = 0.2
    @planet_image.draw(x, y, z, scale, scale)
  end

  def planetfall?
    return @ship_position[:x] > 800 && @ship_position[:y] < 120
  end

  def draw_aliens
    cent = 0.5
    scale = 0.3
    @aliens.each do |a|
      @alien_image.draw_rot(a[:x], a[:y], 2, a[:rot], cent, cent,scale,scale)
    end
  end

  def draw
    @background_image.draw(0,0,0)
    draw_ship
    draw_aliens
    draw_planet
  end
end
