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

    @character = Bug.new(MAX_X/2, MAX_Y/2, 135, 20, 0.1, 1.7854, 80, 150)
    @character_img = Circle.new(@character.position_vec.x, @character.position_vec.y, 5)

    randomize_target
    @tgt_img = Circle.new(@bad_guy.position_vec.x, @bad_guy.position_vec.y, 5)

    # Visual artifacts to illustrate what's going on...
    @heading_line = Line.new(@character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE))
    @steering_force_line  = Line.new(@character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE))

    @intercept_img = Circle.new(0, 0, 4)
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

    steering_force = SteeringBehaviors::Separation.steer(@character, @bad_guy, 150)
    SteeringBehaviors::Steering.feel_the_force(@character, steering_force, delta_s, false)
    @character.move(delta_s)
    @bad_guy.move(delta_s)

    # Wrap at edges
    @character.position_vec.x = 0 if @character.position_vec.x > MAX_X
    @character.position_vec.y = 0 if @character.position_vec.y > MAX_Y
    @character.position_vec.x = MAX_X if @character.position_vec.x < 0
    @character.position_vec.y = MAX_Y if @character.position_vec.y < 0

    @bad_guy.position_vec.x = 0 if @bad_guy.position_vec.x > MAX_X
    @bad_guy.position_vec.y = 0 if @bad_guy.position_vec.y > MAX_Y
    @bad_guy.position_vec.x = MAX_X if @bad_guy.position_vec.x < 0
    @bad_guy.position_vec.y = MAX_Y if @bad_guy.position_vec.y < 0

    # Revise the visual artifacts
    @character_img.setCenterX @character.position_vec.x
    @character_img.setCenterY @character.position_vec.y

    @tgt_img.setCenterX @bad_guy.position_vec.x
    @tgt_img.setCenterY @bad_guy.position_vec.y

    @heading_line.set @character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE)

    @steering_force_line.set @character.position_vec.x, @character.position_vec.y,
      (steering_force.x + @character.position_vec.x),
      (steering_force.y + @character.position_vec.y)

    if (@bad_guy.position_vec.x - @character.position_vec.x).abs < 10 && (@bad_guy.position_vec.y - @character.position_vec.y).abs < 10
      randomize_target
    end
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
    g.draw @tgt_img

    g.setColor(Color.white)
    g.draw @intercept_img
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
      randomize_target
    elsif key==Input::KEY_P
      if @container.isPaused
        @container.resume
      else
        @container.pause
      end
    end
  end

  # Place the quarry somewhere random...
  def randomize_target
    @bad_guy = Bug.new(rand(0..MAX_X), rand(0..MAX_Y), rand(360), 50, 0, 0, 0,0)
  end
end
