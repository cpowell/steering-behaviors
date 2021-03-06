##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

require 'bug'

class PursueEvadeComboState < BasicGameState
  ID = 13 # Unique ID for this Slick game state

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
    @game = game
    @container = container

    randomize_things

    @character_img = Circle.new(@character.position_vec.x, @character.position_vec.y, 6)
    @enemy_img = Circle.new(@enemy.position_vec.x, @enemy.position_vec.y, 6)

    # Visual artifacts to illustrate what's going on...
    @char_heading_line = Line.new(@character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE))
    @enemy_heading_line = Line.new(@enemy.position_vec.x, @enemy.position_vec.y, (@enemy.position_vec.x + @enemy.heading_vec.x * VISUAL_SCALE), (@enemy.position_vec.y + @enemy.heading_vec.y * VISUAL_SCALE))

    @char_steering_force_line  = Line.new(@character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE))
    @enemy_steering_force_line  = Line.new(@enemy.position_vec.x, @enemy.position_vec.y, (@enemy.position_vec.x + @enemy.heading_vec.x * VISUAL_SCALE), (@enemy.position_vec.y + @enemy.heading_vec.y * VISUAL_SCALE))

    @char_future_pos_img = Circle.new(0, 0, 3)
    @enemy_future_pos_img = Circle.new(0, 0, 3)
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

    predicted_char_position, enemy_steering_force = SteeringBehaviors::Pursue.steer(@enemy, @character)
    SteeringBehaviors::Steering.feel_the_force(@enemy, enemy_steering_force, delta_s)

    predicted_enemy_position, char_steering_force = SteeringBehaviors::Evade.steer(@character, @enemy)
    SteeringBehaviors::Steering.feel_the_force(@character, char_steering_force, delta_s)

    @character.move(delta_s)
    @enemy.move(delta_s)

    # Wrap at edges
    if @character.position_vec.x > MAX_X || @character.position_vec.y > MAX_Y ||
      @character.position_vec.x < 0 || @character.position_vec.y < 0
      randomize_things
    end

    @enemy.position_vec.x = 0 if @enemy.position_vec.x > MAX_X
    @enemy.position_vec.y = 0 if @enemy.position_vec.y > MAX_Y
    @enemy.position_vec.x = MAX_X if @enemy.position_vec.x < 0
    @enemy.position_vec.y = MAX_Y if @enemy.position_vec.y < 0

    # Revise the visual artifacts
    @character_img.setCenterX @character.position_vec.x
    @character_img.setCenterY @character.position_vec.y

    @enemy_img.setCenterX @enemy.position_vec.x
    @enemy_img.setCenterY @enemy.position_vec.y

    @char_future_pos_img.setCenterX predicted_char_position.x
    @char_future_pos_img.setCenterY predicted_char_position.y
    @enemy_future_pos_img.setCenterX predicted_enemy_position.x
    @enemy_future_pos_img.setCenterY predicted_enemy_position.y

    @char_heading_line.set @character.position_vec.x, @character.position_vec.y, (@character.position_vec.x + @character.heading_vec.x * VISUAL_SCALE), (@character.position_vec.y + @character.heading_vec.y * VISUAL_SCALE)

    @enemy_heading_line.set @enemy.position_vec.x, @enemy.position_vec.y, (@enemy.position_vec.x + @enemy.heading_vec.x * VISUAL_SCALE), (@enemy.position_vec.y + @enemy.heading_vec.y * VISUAL_SCALE)

    @char_steering_force_line.set @character.position_vec.x, @character.position_vec.y,
      (char_steering_force.x + @character.position_vec.x),
      (char_steering_force.y + @character.position_vec.y)

    @enemy_steering_force_line.set @enemy.position_vec.x, @enemy.position_vec.y,
      (enemy_steering_force.x + @enemy.position_vec.x),
      (enemy_steering_force.y + @enemy.position_vec.y)

    # If the enemy catches the char, start over
    if (@enemy.position_vec.x - @character.position_vec.x).abs < 10 && (@enemy.position_vec.y - @character.position_vec.y).abs < 10
      randomize_things
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
    g.draw_string("Pursuit and Evasion Combo (p to pause, r to randomize, ESC to exit)", 8, container.height - 30)

    data = sprintf("Crs %.2f\nSpd %2.0f", @character.velocity_vec.radians, @character.velocity_vec.length)
    g.draw_string(data, @character.position_vec.x+10, @character.position_vec.y+10)

    data = sprintf("Crs %.2f\nSpd %2.0f", @enemy.velocity_vec.radians, @enemy.velocity_vec.length)
    g.draw_string(data, @enemy.position_vec.x+10, @enemy.position_vec.y+10)

    g.setColor(Color.green)
    g.draw @character_img
    g.draw @char_future_pos_img

    g.setColor(Color.red)
    g.draw @char_heading_line
    g.draw @enemy_heading_line

    g.setColor(Color.cyan)
    g.draw @char_steering_force_line
    g.draw @enemy_steering_force_line

    g.setColor(Color.yellow)
    g.draw @enemy_img
    g.draw @enemy_future_pos_img

    g.setColor(Color.cyan)
  end

  # Notification that a key was released
  #
  # * *Args*    :
  #   - +key+ -> the slick.Input key code that was sent
  #   - +char+ -> the ASCII decimal character-code that was sent
  #
  def keyReleased(key, char)
    if key==Input::KEY_ESCAPE
      @game.enterState(1, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_R
      randomize_things
    elsif key==Input::KEY_P
      if @container.isPaused
        @container.resume
      else
        @container.pause
      end
    end
  end

  # Place the quarry somewhere random...
  def randomize_things
    @character = Bug.new(MAX_X/2, MAX_Y/2, rand(360), rand(5..50), rand(0.2..1.3), Math::PI/2, 5, rand(30..60))
    @enemy = Bug.new(rand(0..MAX_X), rand(0..MAX_Y), rand(360), rand(5..75), rand(0.2..1.3), Math::PI/4, 5, rand(40..150))
  end
end
