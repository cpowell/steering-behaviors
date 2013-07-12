##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'bug'

class PursueState < BasicGameState
  ID = 5 # Unique ID for this Slick game state

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

    @hunter = Bug.new(MAX_X/8, MAX_Y/8, 135, 100, 0.1, 1.7854, 50, 150)
    @hunter_img = Circle.new(@hunter.position_vec.x, @hunter.position_vec.y, 5)

    randomize_target
    @tgt_img = Circle.new(@quarry.position_vec.x, @quarry.position_vec.y, 5)

    # Visual artifacts to illustrate what's going on...
    @heading_line = Line.new(@hunter.position_vec.x, @hunter.position_vec.y, (@hunter.position_vec.x + @hunter.heading_vec.x * VISUAL_SCALE), (@hunter.position_vec.y + @hunter.heading_vec.y * VISUAL_SCALE))
    @steering_force_line  = Line.new(@hunter.position_vec.x, @hunter.position_vec.y, (@hunter.position_vec.x + @hunter.heading_vec.x * VISUAL_SCALE), (@hunter.position_vec.y + @hunter.heading_vec.y * VISUAL_SCALE))

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

    predicted_position, steering_force = SteeringBehaviors::Pursue.steer(@hunter, @quarry)
    SteeringBehaviors::Steering.feel_the_force(@hunter, steering_force, delta_s)
    @hunter.move(delta_s)
    @quarry.move(delta_s)

    # Wrap at edges
    @hunter.position_vec.x = 0 if @hunter.position_vec.x > MAX_X
    @hunter.position_vec.y = 0 if @hunter.position_vec.y > MAX_Y
    @hunter.position_vec.x = MAX_X if @hunter.position_vec.x < 0
    @hunter.position_vec.y = MAX_Y if @hunter.position_vec.y < 0

    @quarry.position_vec.x = 0 if @quarry.position_vec.x > MAX_X
    @quarry.position_vec.y = 0 if @quarry.position_vec.y > MAX_Y
    @quarry.position_vec.x = MAX_X if @quarry.position_vec.x < 0
    @quarry.position_vec.y = MAX_Y if @quarry.position_vec.y < 0

    # Revise the visual artifacts
    @hunter_img.setCenterX @hunter.position_vec.x
    @hunter_img.setCenterY @hunter.position_vec.y

    @tgt_img.setCenterX @quarry.position_vec.x
    @tgt_img.setCenterY @quarry.position_vec.y

    @intercept_img.setCenterX predicted_position.x
    @intercept_img.setCenterY predicted_position.y

    @heading_line.set @hunter.position_vec.x, @hunter.position_vec.y, (@hunter.position_vec.x + @hunter.heading_vec.x * VISUAL_SCALE), (@hunter.position_vec.y + @hunter.heading_vec.y * VISUAL_SCALE)

    @steering_force_line.set @hunter.position_vec.x, @hunter.position_vec.y,
      (steering_force.x + @hunter.position_vec.x),
      (steering_force.y + @hunter.position_vec.y)

    if (@quarry.position_vec.x - @hunter.position_vec.x).abs < 10 && (@quarry.position_vec.y - @hunter.position_vec.y).abs < 10
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
    g.draw_string("Pursuing (p to pause, ESC to exit)", 8, container.height - 30)

    g.setColor(Color.green)
    g.draw(@hunter_img)

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
    @quarry = Bug.new(rand(MAX_X/2..MAX_X), rand(MAX_Y/2..MAX_Y), rand(360), rand(50..120), 0, 0, 0,0)
  end
end
