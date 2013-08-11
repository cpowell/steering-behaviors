##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'bug'

class SeparationState < BasicGameState

  ID = 12 # Unique ID for this Slick game state

  VISUAL_SCALE = 50
  MAX_X = 800
  MAX_Y = 800
  MAX_TGT_VEL = 100
  DANGER_RADIUS = 150

  # Required by StateBasedGame
  def getID
    ID
  end

  # Before you start the game loop, you can initialize any data you wish
  # inside the method init.
  #
  # * *Args*    :
  #   - +container+ -> game container
  #   - +game+ -> the game itself
  #
  def init(container, game)
    @container = container

    @character = Bug.new(MAX_X/2, MAX_Y/2, 135, 20, 0.1, 1.7854, 80, 250)
    @character_img = Circle.new(@character.position_vec.x, @character.position_vec.y, 5)

    randomize_targets

    # Visual artifacts to illustrate what's going on...
    @heading_line = Line.new(@character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE))
    @steering_force_line  = Line.new(@character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE))

    @intercept_img = Circle.new(0, 0, 4)
  end

  def compute_nearest_approach_time(character_kinematic, other_kinematic)
    relative_vel_vec = other_kinematic.velocity_vec - character_kinematic.velocity_vec
    relative_speed = relative_vel_vec.length

    return 0 if relative_speed==0

    relative_tangent_vec = relative_vel_vec / relative_speed
    relative_position_vec = character_kinematic.position_vec - other_kinematic.position_vec

    projection = relative_tangent_vec.dot(relative_position_vec)
    return projection / relative_speed
  end


  # The update method is called during the game to update the logic in our
  # world, within this method we can obtain the user input, calculate the
  # world response to the input, do extra calculation like the AI of the
  # enemies, etc. Your game logic goes here.
  #
  # * *Args*    :
  #   - +container+ -> game container
  #   - +g+ -> graphics context that can be used to render
  #   - +delta+ -> timeslice in seconds
  #
  def update(container, game, delta)
    delta_s = delta / 1000.0

    @min_time = 10 # seconds of look-ahead
    @worst_threat = nil

    # As we're updating all the movers, choose the 'worst threat'. This is
    # the threat with the lowest time-to-closest-approach. Once identified,
    # that threat will be separated-from if it will penetrate DANGER_RADIUS.
    # This minimum-CPA method is naive and doesn't always truly identify
    # the most pressing threat, as you'll see in the example, but works well
    # enough for a demo.

    @bad_guys.each_with_index do |bg, i|
      bg.move(delta_s)
      bg.position_vec.x = 0 if bg.position_vec.x > MAX_X
      bg.position_vec.y = 0 if bg.position_vec.y > MAX_Y
      bg.position_vec.x = MAX_X if bg.position_vec.x < 0
      bg.position_vec.y = MAX_Y if bg.position_vec.y < 0

      @tgt_imgs[i].setCenterX bg.position_vec.x
      @tgt_imgs[i].setCenterY bg.position_vec.y

      cpa_time = compute_nearest_approach_time(@character, bg)
      @bad_cpa_times[i] = cpa_time
      if cpa_time >= 0 && cpa_time < @min_time
        @worst_threat = i
        @min_time = cpa_time
      end
    end

    if @worst_threat
      steering_force = SteeringBehaviors::Separation.steer(@character, @bad_guys[@worst_threat], DANGER_RADIUS)
      SteeringBehaviors::Steering.feel_the_force(@character, steering_force, delta_s, false)
    else
      steering_force = SteeringBehaviors::VEC_ZERO
    end

    @character.move(delta_s)

    # Wrap at edges
    @character.position_vec.x = 0 if @character.position_vec.x > MAX_X
    @character.position_vec.y = 0 if @character.position_vec.y > MAX_Y
    @character.position_vec.x = MAX_X if @character.position_vec.x < 0
    @character.position_vec.y = MAX_Y if @character.position_vec.y < 0

    # Revise the visual artifacts
    @character_img.setCenterX @character.position_vec.x
    @character_img.setCenterY @character.position_vec.y

    @heading_line.set @character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE)

    @steering_force_line.set @character.position_vec.x, @character.position_vec.y,
      (steering_force.x + @character.position_vec.x),
      (steering_force.y + @character.position_vec.y)

  end

  # After that the render method allows us to draw the world we designed
  # accordingly to the variables calculated in the update method.
  #
  # * *Args*    :
  #   - +container+ -> game container
  #   - +g+ -> graphics context that can be used to render
  #
  def render(container, game, g)
    g.setColor(Color.white)
    g.draw_string("Separating (p to pause, r to randomize, ESC to exit)", 8, container.height - 30)
    data = sprintf("Crs %.2f\nSpd %2.0f", @character.velocity_vec.radians, @character.velocity_vec.length)
    g.draw_string(data, @character.position_vec.x+10, @character.position_vec.y+10)

    g.setColor(Color.green)
    g.draw(@character_img)

    g.setColor(Color.red)
    g.draw @heading_line

    g.setColor(Color.cyan)
    g.draw @steering_force_line

    g.setColor(Color.yellow)
    @tgt_imgs.each_with_index do |img, i|
       g.draw img
       g.draw_string(sprintf("%.1f", @bad_cpa_times[i]), img.x+10, img.y+10) unless @bad_cpa_times[i].nil?
    end


    g.setColor(Color.red)
    g.draw(@tgt_imgs[@worst_threat]) if @worst_threat

    g.setColor(Color.white)
    g.draw @intercept_img

    if @worst_threat
      notice = sprintf("Worst threat is %s, CPA in %.1f secs", @worst_threat, @min_time)
      g.draw_string(notice, 8, container.height/2)
    end
  end

  # Notification that a key was released
  #
  # * *Args*    :
  #   - +key+ -> the slick.Input key code that was sent
  #   - +char+ -> the ASCII decimal character-code that was sent
  #
  def keyReleased(key, char)
    if key==Input::KEY_ESCAPE
      @container.exit
    elsif key==Input::KEY_R
      randomize_targets
    elsif key==Input::KEY_P
      if @container.isPaused
        @container.resume
      else
        @container.pause
      end
    end
  end

  # Place the quarry somewhere random...
  def randomize_targets
    @bad_guys=[]
    @bad_cpa_times=[]
    @tgt_imgs=[]
    10.times do |i|
      @bad_guys[i] = Bug.new(rand(0..MAX_X), rand(0..MAX_Y), rand(360), 50, 0, 0, 0,0)
      @tgt_imgs[i] = Circle.new(@bad_guys[i].position_vec.x, @bad_guys[i].position_vec.y, 5)
    end
  end
end
