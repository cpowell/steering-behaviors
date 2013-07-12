##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

require 'bug'

class WanderState < BasicGameState
  ID = 2 # Unique ID for this Slick game state

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

    @bug = Bug.new(400, 400, 135, 100, 0.1, 1.7854, 50, 150)

    @bug_img = Circle.new(@bug.position_vec.x, @bug.position_vec.y, 5)

    # Visual artifacts to illustrate what's going on...
    @steering_circle = Circle.new(@bug.position_vec.x, @bug.position_vec.y, VISUAL_SCALE)
    @heading_line    = Line.new(@bug.position_vec.x, @bug.position_vec.y, (@bug.position_vec.x + @bug.heading_vec.x * VISUAL_SCALE), (@bug.position_vec.y + @bug.heading_vec.y * VISUAL_SCALE))
    @end_point       = Circle.new(@bug.position_vec.x, @bug.position_vec.y, 4)
    @steering_force  = Line.new(@bug.position_vec.x, @bug.position_vec.y, (@bug.position_vec.x + @bug.heading_vec.x * VISUAL_SCALE), (@bug.position_vec.y + @bug.heading_vec.y * VISUAL_SCALE))
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

    steering_force = SteeringBehaviors::Wander.steer(@bug, 0.4)
    SteeringBehaviors::Steering.feel_the_force(@bug, steering_force * 4, delta_s)
    @bug.move(delta_s)

    # Wrap at edges
    @bug.position_vec.x = 0 if @bug.position_vec.x > MAX_X
    @bug.position_vec.y = 0 if @bug.position_vec.y > MAX_Y
    @bug.position_vec.x = MAX_X if @bug.position_vec.x < 0
    @bug.position_vec.y = MAX_Y if @bug.position_vec.y < 0

    # Revise the visual artifacts
    @bug_img.setCenterX @bug.position_vec.x
    @bug_img.setCenterY @bug.position_vec.y

    @steering_circle.setCenterX @bug.position_vec.x
    @steering_circle.setCenterY @bug.position_vec.y

    @heading_line.set @bug.position_vec.x, @bug.position_vec.y, (@bug.position_vec.x + @bug.heading_vec.x * VISUAL_SCALE), (@bug.position_vec.y + @bug.heading_vec.y * VISUAL_SCALE)

    @end_point.setCenterX steering_force.x * VISUAL_SCALE + @bug.position_vec.x
    @end_point.setCenterY steering_force.y * VISUAL_SCALE + @bug.position_vec.y

    @steering_force.set @bug.position_vec.x, @bug.position_vec.y, @end_point.getCenterX, @end_point.getCenterY

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
    g.draw_string("Wandering (p to pause, ESC to exit)", 8, container.height - 30)

    g.setColor(Color.green)
    g.draw(@bug_img)

    g.setColor(Color.blue)
    g.draw @steering_circle

    g.setColor(Color.red)
    g.draw @heading_line

    g.setColor(Color.yellow)
    g.draw @end_point

    g.setColor(Color.cyan)
    g.draw @steering_force
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

end