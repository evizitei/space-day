require 'securerandom'

class FlyLevel
  def initialize(dim)
    @dim = dim
    @ship_image = Gosu::Image.new("assets/ship.png")
  end

  def reset_level!
    @ship_position = {
      x: 30,
      y: 680,
      rot: 90
    }
  end

  def random_rotation
    SecureRandom.rand * 360
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

  def move_by(x, y, rot, speed: 1)
    useful_rot = calc_new_rotation(rot, 90)
    rads = useful_rot * ((2*Math::PI) / 360)
    x_comp = Math::cos(rads) * speed
    y_comp = Math::sin(rads) * speed
    factor = -1
    return {
      x: x + (factor * x_comp),
      y: y + (factor * y_comp)
    }
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

  def collided?(pos1, pos2, threshold: 50)
    distance = Math.sqrt(((pos1[:x] - pos2[:x])**2) + ((pos1[:y]-pos2[:y])**2))
    return distance < threshold
  end

  def move_ship(kb=Gosu)
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

  def done?
    return @ship_position[:x] > 820 && @ship_position[:y] < 120
  end
end
