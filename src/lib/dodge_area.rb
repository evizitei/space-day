require 'securerandom'

class DodgeArea
  def initialize(dim)
    @ship_image = Gosu::Image.new("assets/ship.png")
    @planet_image = Gosu::Image.new("assets/planet1.png")
    @satellite_image = Gosu::Image.new("assets/satellite2.png")
    @satellite_image_2 = Gosu::Image.new("assets/satellite.png")
    @dim = dim
    reset_level!
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

  def reset_level!
    @ship_position = {
      x: 30,
      y: 680,
      rot: 90
    }
    @sat_pos = random_init
    @sat_pos_2 = random_init
  end

  def update_position(direction, rot)
    amt = 3
    useful_rot = calc_new_rotation(rot, 90)
    rads = useful_rot * ((2*Math::PI) / 360)
    y_comp = Math::sin(rads) * amt
    x_comp = Math::cos(rads) * amt
    factor = -1
    factor = 1 if direction == :backward
    new_x = @ship_position[:x] + (factor * x_comp)
    new_y = @ship_position[:y] + (factor * y_comp)
    new_y = 0 if new_y < 0
    new_x = 0 if new_x < 0
    new_y = @dim[:h] if new_y > @dim[:h]
    new_x = @dim[:w] if new_x > @dim[:w]
    @ship_position[:x] = new_x
    @ship_position[:y] = new_y
  end

  def calc_new_rotation(rot, amt)
    new_rot = rot + amt
    if new_rot > 360
      new_rot = new_rot - 360
    elsif new_rot < 0
      new_rot = 360 + new_rot
    end
    return new_rot
  end

  def update_rotation(direction)
    rot = @ship_position[:rot]
    rotation_amount = 3
    factor = -1
    factor = 1 if direction == :left
    new_rot = calc_new_rotation(rot, (rotation_amount * factor))
    @ship_position[:rot] = new_rot
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

  def collided?(pos1, pos2)
    distance = Math.sqrt(((pos1[:x] - pos2[:x])**2) + ((pos1[:y]-pos2[:y])**2))
    return distance < 50
  end

  def check_crash
    if collided?(@ship_position, @sat_pos) || collided?(@ship_position, @sat_pos_2)
      reset_level!
    end
  end

  def tick(kb=Gosu)
    if kb.button_down?(Gosu::KB_LEFT)
      update_rotation(:right)
    end

    if kb.button_down?(Gosu::KB_RIGHT)
      update_rotation(:left)
    end

    rot = @ship_position[:rot]
    if kb.button_down?(Gosu::KB_UP)
      update_position(:forward, rot)
    end

    if kb.button_down?(Gosu::KB_DOWN)
      update_position(:backward, rot)
    end
    update_obstacles
    check_crash
  end

  def draw_ship
    x = @ship_position[:x]
    y = @ship_position[:y]
    z = 3
    rot = @ship_position[:rot]
    center = 0.5
    scale = 0.05
    @ship_image.draw_rot(x, y, z, rot, center, center, scale, scale)
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
    draw_ship
    draw_planet
    draw_obstacles
  end
end
