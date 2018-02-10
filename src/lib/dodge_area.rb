class DodgeArea
  def initialize
    @ship_image = Gosu::Image.new("assets/ship.png")
    reset_level!
    @rotation
  end

  def reset_level!
    set_ship_position
  end

  def set_ship_position
    @ship_position = { x: 500, y: 400, rot: 0 }
  end

  def update_position(direction, rot)
    amt = 3
    useful_rot = calc_new_rotation(rot, 90)
    rads = useful_rot * ((2*Math::PI) / 360)
    y_comp = Math::sin(rads) * amt
    x_comp = Math::cos(rads) * amt
    factor = -1
    factor = 1 if direction == :backward
    @ship_position[:x] = @ship_position[:x] + (factor * x_comp)
    @ship_position[:y] = @ship_position[:y] + (factor * y_comp)
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

  def draw
    draw_ship
  end
end
