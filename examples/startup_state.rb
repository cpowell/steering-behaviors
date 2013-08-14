##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class StartupState < BasicGameState
  ID = 1 # Unique ID for this Slick game state

  # Required by StateBasedGame
  def getID
    ID
  end

  # Before you start the game loop, you can initialize any data you wish inside the method init.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #
  def init(container, game)
    @game = game
    @container = container # So I can exit later...
    container.setTargetFrameRate(60)
    container.setAlwaysRender(true)
  end

  # The update method is called during the game to update the logic in our world,
  # within this method we can obtain the user input, calculate the world response
  # to the input, do extra calculation like the AI of the enemies, etc. Your game logic goes here.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +delta+ -> the number of ms since update was last called. We can use it to 'weight' the changes we make.
  #
  def update(container, game, delta)
  end

  # After that the render method allows us to draw the world we designed accordingly
  # to the variables calculated in the update method.
  #
  # * *Args*    :
  #   - +container+ -> game container that handles the game loop, fps recording and managing the input system
  #   - +graphics+ -> graphics context that can be used to render. However, normal rendering routines can also be used.
  #
  def render(container, game, graphics)
    graphics.setColor(Color.white)
    graphics.draw_string("Steering behaviors demo (ESC to exit)", 8, 50)
    graphics.draw_string("http://github.com/cpowell/steering-behaviors", 8, 70)

    graphics.setColor(Color.cyan)
    v = 100
    graphics.draw_string("(Type 'a' to arrive)",     8, v)
    graphics.draw_string("(Type 'w' to wander)",     8, v+=20)

    graphics.draw_string("(Type 'e' to evade)",      8, v+=50)
    graphics.draw_string("(Type 'p' to pursue)",     8, v+=20)
    graphics.draw_string("(Type 'c' to pursue / evade combo)", 8, v+=20)

    graphics.draw_string("(Type 's' to seek)",       8, v+=50)
    graphics.draw_string("(Type 'f' to flee)",       8, v+=20)

    graphics.draw_string("(Type 'g' to align)",      8, v+=50)
    graphics.draw_string("(Type 'm' to match)",      8, v+=20)
    graphics.draw_string("(Type 'o' to orthogonal)", 8, v+=20)
    graphics.draw_string("(Type 'b' to broadside)",  8, v+=20)
    graphics.draw_string("(Type 'r' to separate)",   8, v+=20)

  end

  # Notification that a key was released
  #
  # * *Args*    :
  #   - +key+ -> the slick.Input key code that was sent
  #   - +char+ -> the ASCII decimal character-code that was sent
  #
  def keyReleased(key, char)
    if key==Input::KEY_W
      @game.enterState(WanderState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_S
      @game.enterState(SeekState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_F
      @game.enterState(FleeState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_P
      @game.enterState(PursueState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_A
      @game.enterState(ArriveState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_E
      @game.enterState(EvadeState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_G
      @game.enterState(AlignState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_M
      @game.enterState(MatchState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_B
      @game.enterState(BroadsideState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_O
      @game.enterState(OrthogonalState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_R
      @game.enterState(SeparationState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_C
      @game.enterState(PursueEvadeComboState::ID, FadeOutTransition.new(Color.black), FadeInTransition.new(Color.black))
    elsif key==Input::KEY_ESCAPE
      @container.exit
    end
  end

end

