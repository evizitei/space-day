require 'securerandom'
require_relative './fly_level'

class AsteroidBelt < FlyLevel
  def initialize(dim)
    super(dim)
    @background_image = Gosu::Image.new("assets/level3/background.jpg", tileable: true)
    @planet_image = Gosu::Image.new("assets/level3/planet.png")
    @asteroid_images = [
      Gosu::Image.new("assets/level3/asteroid_1.png"),
      Gosu::Image.new("assets/level3/asteroid_2.png"),
      Gosu::Image.new("assets/level3/asteroid_3.png")
    ]

    reset_level!
  end

  def reset_level!
    super
    @asteroids_count = 4
    @asteroids = []
    @asteroids_count.times do
      asteroid = random_init
      asteroid[:image] = @asteroid_images.sample
      @asteroids << asteroid
    end
  end

  def check_crash
    reset_level! if @asteroids.any?{|ast| collided?(@ship_position, ast, threshold: 75) }
  end

  def random_bounce(asteroid, target)
    x_delta = asteroid[:x] - target[:x]
    nxs = random_speed
    if (nxs > 0 != x_delta > 0)
      nxs = nxs * -1
    end
    asteroid[:x_speed] = nxs

    y_delta = asteroid[:y] - target[:y]
    nys = random_speed
    if (nys > 0 != y_delta > 0)
      nys = nys * -1
    end
    asteroid[:y_speed] = nys
  end

  def check_bounces
    @asteroids.each_with_index do |ast1, i|
      @asteroids.each_with_index do |ast2, j|
        if j > i && collided?(ast1, ast2, threshold: 90)
          random_bounce(ast1, ast2)
          random_bounce(ast2, ast1)
        end
      end
    end
  end

  def move_asteroids
    @asteroids.each do |ast|
      ast_pos = new_position(ast)
      ast[:x] = ast_pos[:x]
      ast[:y] = ast_pos[:y]
      ast[:x_speed] = ast_pos[:x_speed]
      ast[:y_speed] = ast_pos[:y_speed]
    end
  end

  def tick
    move_ship
    move_asteroids
    check_bounces
    check_crash
  end

  def draw_planet
    x = 800
    y = 1
    z = 2
    scale = 0.2
    @planet_image.draw(x, y, z, scale, scale)
  end

  def draw_asteroids
    @asteroids.each do |ast|
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
    draw_asteroids
  end
end
