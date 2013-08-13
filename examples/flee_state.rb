##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

require 'bug'

class FleeState < BasicGameState
  ID = 4 # Unique ID for this Slick game state

  VISUAL_SCALE = 50
  MAX_X = 800
  MAX_Y = 800

  # Required by StateBasedGame
  def getID
    ID
  end

  # Before you start the game loop, you can initialize any data you wish
  # inside the method init.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #
  def init(container, game)
    @container = container

    @bug = Bug.new(MAX_X/8, MAX_Y/8, 135, 100, 1.0, 1.7854, 15, 150)
    @bug_img = Circle.new(@bug.position_vec.x, @bug.position_vec.y, 5)

    randomize_target
    @tgt_img = Circle.new(@target_pos.x, @target_pos.y, 5)

    # Visual artifacts to illustrate what's going on...
    @heading_line    = Line.new(@bug.position_vec.x, @bug.position_vec.y, (@bug.position_vec.x + @bug.heading_vec.x * VISUAL_SCALE), (@bug.position_vec.y + @bug.heading_vec.y * VISUAL_SCALE))
    @steering_force_line  = Line.new(@bug.position_vec.x, @bug.position_vec.y, (@bug.position_vec.x + @bug.heading_vec.x * VISUAL_SCALE), (@bug.position_vec.y + @bug.heading_vec.y * VISUAL_SCALE))
    @intercept_img = Circle.new(0, 0, 4)
  end

  # The update method is called during the game to update the logic in our
  # world, within this method we can obtain the user input, calculate the
  # world response to the input, do extra calculation like the AI of the
  # enemies, etc. Your game logic goes here.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +delta+ -> the number of ms since update was last called. We can use it to 'weight' the changes we make.
  #
  def update(container, game, delta)
    delta_s = delta / 1000.0

    steering_force = SteeringBehaviors::Flee.steer(@bug, @target_pos)
    SteeringBehaviors::Steering.feel_the_force(@bug, steering_force, delta_s, true)
    @bug.move(delta_s)

    # Wrap at edges
    if @bug.position_vec.x > MAX_X || @bug.position_vec.y > MAX_Y ||
    @bug.position_vec.x < 0 || @bug.position_vec.y < 0
      randomize_target
      @bug.position_vec.x = rand(MAX_X)
      @bug.position_vec.y = rand(MAX_Y)
    end

    # Revise the visual artifacts
    @bug_img.setCenterX @bug.position_vec.x
    @bug_img.setCenterY @bug.position_vec.y

    @tgt_img.setCenterX @target_pos.x
    @tgt_img.setCenterY @target_pos.y

    # @steering_circle.setCenterX @bug.position_vec.x
    # @steering_circle.setCenterY @bug.position_vec.y

    @heading_line.set @bug.position_vec.x, @bug.position_vec.y, (@bug.position_vec.x + @bug.heading_vec.x * VISUAL_SCALE), (@bug.position_vec.y + @bug.heading_vec.y * VISUAL_SCALE)

    @steering_force_line.set @bug.position_vec.x, @bug.position_vec.y,
      (steering_force.x + @bug.position_vec.x),
      (steering_force.y + @bug.position_vec.y)

    if (@target_pos.x - @bug.position_vec.x).abs < 10 && (@target_pos.y - @bug.position_vec.y).abs < 10
      randomize_target
    end

    # printf "Crs: %0.4f  Hdg: %0.4f  Spd: %0.1f\n", @bug.velocity_vec.radians, @bug.heading_vec.radians, @bug.speed
  end

  # After that the render method allows us to draw the world we designed
  # accordingly to the variables calculated in the update method.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +g+ -> graphics context that can be used to render. However, normal rendering routines can also be used.
  #
  def render(container, game, g)
    # Make sure you "layer" things in here from bottom to top...
    # @bg_image.draw(0, 0)

    g.setColor(Color.white)
    g.draw_string("Fleeing (p to pause, ESC to exit)", 8, container.height - 30)
    data = sprintf("Crs %.2f\nSpd %2.0f", @bug.velocity_vec.radians, @bug.velocity_vec.length)
    g.draw_string(data, @bug.position_vec.x+10, @bug.position_vec.y+10)

    g.setColor(Color.green)
    g.draw(@bug_img)

    g.setColor(Color.red)
    g.draw @heading_line

    g.setColor(Color.cyan)
    g.draw @steering_force_line

    g.setColor(Color.yellow)
    g.draw @tgt_img
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

  def randomize_target
    @target_pos = SteeringBehaviors::Vector.new(rand(0..MAX_X), rand(0..MAX_Y))
  end
end
