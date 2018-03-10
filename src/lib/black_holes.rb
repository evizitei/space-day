require 'securerandom'
require_relative './fly_level'

class BlackHoles < FlyLevel
  def initialize(dim)
    super(dim)
    @background_image = Gosu::Image.new("assets/level4/background.jpg", tileable: true)
    @planet_image = Gosu::Image.new("assets/level4/planet.png")
    @blackhole_images = [
      Gosu::Image.new("assets/level4/blackhole1.png"),
      Gosu::Image.new("assets/level4/blackhole2.png"),
      Gosu::Image.new("assets/level4/blackhole3.png")
    ]

    reset_level!
  end

  def blackhole_init(i)
    positions = [
      { x: 750, y: 400},
      { x: 30, y: 90},
      { x: 120, y: 240},
      { x: 500, y: 120},
      { x: 900, y: 650},
      { x: 500, y: 500}
    ]
    return random_init.merge(positions[i])
  end

  def reset_level!
    super
    @blackhole_count = 6
    @blackholes = []
    @blackhole_count.times do |i|
      black_hole = blackhole_init(i)
      black_hole[:image] = @blackhole_images.sample
      @blackholes << black_hole
    end
  end

  def check_crash
    reset_level! if @blackholes.any?{|ast| collided?(@ship_position, ast, threshold: 50) }
  end

  def account_for_gravity
    gravitational_constant = 35000
    @blackholes.each do |bh|
      x_dist = bh[:x] - @ship_position[:x]
      y_dist = bh[:y] - @ship_position[:y]
      vector_dist = Math.sqrt((x_dist ** 2) + (y_dist ** 2))
      x_move_comp = x_dist / vector_dist
      y_move_comp = y_dist / vector_dist
      x_scaled_move = x_move_comp * ( gravitational_constant/ (vector_dist ** 2) )
      y_scaled_move = y_move_comp * ( gravitational_constant/ (vector_dist ** 2) )
      @ship_position[:x] += x_scaled_move
      @ship_position[:y] += y_scaled_move
    end
  end

  def tick
    move_ship
    account_for_gravity
    check_crash
  end

  def draw_planet
    x = 800
    y = 1
    z = 2
    scale = 0.2
    @planet_image.draw(x, y, z, scale, scale)
  end

  def draw_blackholes
    @blackholes.each do |ast|
      x = ast[:x]
      y = ast[:y]
      rot = ast[:rot]
      center = 0.5
      scale = 0.2
      img = ast[:image]
      img.draw_rot(x, y, 2, rot, center, center, scale, scale)
    end
  end

  def draw
    @background_image.draw(0,0,0)
    draw_ship
    draw_planet
    draw_blackholes
  end
end
