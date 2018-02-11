
class LanderScene
  def initialize(dim)
    @background_image = Gosu::Image.new("assets/lander_background.jpg", tileable: true)
    @ship_image = Gosu::Image.new("assets/ship.png")
    @flame_image = Gosu::Image.new("assets/engine-flame.png")
    @astronaut_image = Gosu::Image.new("assets/astronaut.png")
    @dim = dim
    @done = false
    @start_time = -1
    reset_level!
  end

  def reset_level!
    @ship_pos = {
      x: 100,
      y: 36,
      rot: 0
    }
    @flame_pos = {
      x: 99,
      y: 110,
      rot: 0
    }
    @astronaut_pos = {
      x: 150,
      y: @dim[:h] - 60,
      rot: 0
    }
    @speed = 9
    @landed = false
    @fanfare_played = false
    @success_text = Gosu::Image.from_text("Nice Work!", 120, {font: "Arial Black"})
  end

  def draw_ship
    x = @ship_pos[:x]
    y = @ship_pos[:y]
    z = 3
    rot = @ship_pos[:rot]
    center = 0.5
    scale = 0.05
    @ship_image.draw_rot(x, y, z, rot, center, center, scale, scale)
  end

  def draw_flame
    unless @landed
      x = @flame_pos[:x]
      y = @flame_pos[:y]
      z = 2
      rot = @flame_pos[:rot]
      center = 0.5
      scale = 0.5
      @flame_image.draw_rot(x, y, z, rot, center, center, scale, scale)
    end
  end

  def draw_astronaut
    if @landed
      x = @astronaut_pos[:x]
      y = @astronaut_pos[:y]
      z = 2
      rot = @astronaut_pos[:rot]
      center = 0.5
      scale = 1.0
      @astronaut_image.draw_rot(x, y, z, rot, center, center, scale, scale)
    end
  end

  def draw_success_message
    if @landed
      x = 270
      y = 130
      @success_text.draw(x, y, 5)
    end
  end

  def draw
    @background_image.draw(0,0,0)
    draw_ship
    draw_flame
    draw_astronaut
    draw_success_message
  end

  def update_position
    @ship_pos[:y] += @speed
    @flame_pos[:y] += @speed
  end

  def slow_down
    @speed = @speed * 0.986
  end

  def play_victory_sound
    music = Gosu::Sample.new("assets/victory.mp3")
    music.play
  end

  def check_end_condition
    if @ship_pos[:y] >= (@dim[:h] - 55)
      @landed = true
    end

    if @landed && !@fanfare_played
      play_victory_sound
      @fanfare_played = true
      @start_time = Gosu.milliseconds
    end

    if @start_time >= 0
      elapsed = Gosu.milliseconds - @start_time
      @done = true if elapsed > 5000
    end
  end

  def tick
    check_end_condition
    unless @landed
      update_position
      slow_down
    end
  end

  def done?
    @done
  end

end
