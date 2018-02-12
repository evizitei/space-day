require 'securerandom'
require_relative './fly_level'

class DodgeArea < FlyLevel
  def initialize(dim)
    super(dim)
    @background_image = Gosu::Image.new("assets/background.jpg", tileable: true)
    @planet_image = Gosu::Image.new("assets/planet1.png")
    @satellite_image = Gosu::Image.new("assets/satellite2.png")
    @satellite_image_2 = Gosu::Image.new("assets/satellite.png")
    reset_level!
  end

  def random_init
    x_seed = SecureRandom.rand
    y_seed = SecureRandom.rand
    xs_seed = SecureRandom.rand
    ys_seed = SecureRandom.rand
    {
      x: x_seed * @dim[:w],
      y: y_seed * @dim[:h],
      rot: random_rotation,
      x_speed: (xs_seed * 6) - 3,
      y_speed: (ys_seed * 6) - 3
    }
  end

  def reset_level!
    super
    @sat_pos = random_init
    @sat_pos_2 = random_init
  end

  def new_debris_position(pos)
    xs = pos[:x_speed]
    ys = pos[:y_speed]
    if (pos[:x] < 0 && xs < 0) || (pos[:x] > @dim[:w] && xs > 0)
      xs = xs * -1
    end
    if (pos[:y] < 0 && ys < 0) || (pos[:y] > @dim[:h] && ys > 0)
      ys = ys * -1
    end
    return pos.merge({
      x: pos[:x] + pos[:x_speed],
      y: pos[:y] + pos[:y_speed],
      x_speed: xs,
      y_speed: ys
    })
  end

  def update_obstacles
    @sat_pos = new_debris_position(@sat_pos)
    @sat_pos_2 = new_debris_position(@sat_pos_2)
  end

  def check_crash
    if collided?(@ship_position, @sat_pos) || collided?(@ship_position, @sat_pos_2)
      reset_level!
    end
  end

  def tick()
    move_ship
    update_obstacles
    check_crash
  end

  def draw_planet
    x = 800
    y = 1
    z = 2
    scale = 0.2
    @planet_image.draw(x, y, z, scale, scale)
  end

  def draw_obstacles
    x = @sat_pos[:x]
    y = @sat_pos[:y]
    rot = @sat_pos[:rot]
    center = 0.5
    scale = 1
    @satellite_image.draw_rot(x, y, 2, rot, center, center, scale, scale)

    x2 = @sat_pos_2[:x]
    y2 = @sat_pos_2[:y]
    rot2 = @sat_pos_2[:rot]
    center2 = 0.5
    scale2 = 0.3
    @satellite_image_2.draw_rot(x2, y2, 2, rot2, center2, center2, scale2, scale2)
  end

  def draw
    @background_image.draw(0,0,0)
    draw_ship
    draw_planet
    draw_obstacles
  end
end
