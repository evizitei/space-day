require 'securerandom'
require_relative './fly_level'

class AlienInvasion < FlyLevel
  def initialize(dim)
    super(dim)
    @background_image = Gosu::Image.new("assets/level2/background.jpg", tileable: true)
    @planet_image = Gosu::Image.new("assets/level2/planet.png")
    @alien_image = Gosu::Image.new("assets/level2/alien_ship.png")
    @laser_image = Gosu::Image.new("assets/level2/laser.png")
    reset_level!
  end

  def reset_level!
    super
    @aliens = [
      { x: 100 , y: 100, rot: 0 },
      { x: 500 , y: 200, rot: 0 },
      { x: 800 , y: 360, rot: 0 }
    ]
    @lasers = []
    @last_bolt = Gosu.milliseconds
  end

  def build_new_bolt(a)
    new_bolt = { x: a[:x], y: a[:y], rot: random_rotation }
    bolt_distance = 85
    new_bolt = new_bolt.merge(move_by(new_bolt[:x], new_bolt[:y], new_bolt[:rot], speed: bolt_distance))
    return new_bolt
  end

  def fire_lasers
    if Gosu.milliseconds - @last_bolt > 500
      emitter = @aliens.sample
      @lasers << build_new_bolt(emitter)
      @last_bolt = Gosu.milliseconds
    end
  end

  def move_lasers
    laser_speed = 3
    @lasers.each do |l|
      new_position = move_by(l[:x], l[:y], l[:rot], speed: laser_speed)
      l[:x] = new_position[:x]
      l[:y] = new_position[:y]
    end
    done = @lasers.select do |l|
      return (
        l[:x] < -10 || l[:y] < -10 || l[:x] > @dim[:w] + 10 || l[:y] > @dim[:h] + 10
      )
    end
    done.each{|l| @lasers.delete(l) }
  end

  def check_crash
    reset_level! if @lasers.any?{|l| collided?(@ship_position, l, threshold: 30) }
  end

  def tick
    move_ship
    fire_lasers
    move_lasers
    check_crash
  end

  def draw_planet
    x = 800
    y = 1
    z = 2
    scale = 0.2
    @planet_image.draw(x, y, z, scale, scale)
  end

  def draw_aliens
    cent = 0.5
    scale = 0.3
    @aliens.each do |a|
      @alien_image.draw_rot(a[:x], a[:y], 2, a[:rot], cent, cent,scale,scale)
    end
  end

  def draw_lasers
    cent = 0.5
    scale = 1.3
    @lasers.each do |l|
      @laser_image.draw_rot(l[:x], l[:y], 2, l[:rot], cent, cent,scale,scale)
    end
  end

  def draw
    @background_image.draw(0,0,0)
    draw_ship
    draw_aliens
    draw_planet
    draw_lasers
  end
end
