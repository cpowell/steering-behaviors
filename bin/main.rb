##
# Copyright 2012, Prylis Incorporated.
#
# This file is part of The Ruby Entity-Component Framework.
# https://github.com/cpowell/ruby-entity-component-framework
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.


# This class exists as a main entry point for the JRuby application,
# whether run from the .rb files or as a compiled jar.

$:.push File.expand_path('../../lib/', __FILE__)
$:.push File.expand_path('../../lib/ruby/', __FILE__)
$:.push File.expand_path('../../lib/steering-behaviors/', __FILE__)

require 'java'
require 'lwjgl.jar'
require 'slick.jar'

java_import org.newdawn.slick.state.BasicGameState
java_import org.newdawn.slick.state.GameState
java_import org.newdawn.slick.state.StateBasedGame
java_import org.newdawn.slick.GameContainer
java_import org.newdawn.slick.Graphics
java_import org.newdawn.slick.Input
java_import org.newdawn.slick.SlickException
java_import org.newdawn.slick.AppGameContainer
java_import org.newdawn.slick.state.transition.FadeInTransition
java_import org.newdawn.slick.state.transition.FadeOutTransition
java_import org.newdawn.slick.Color
java_import org.newdawn.slick.geom.Circle
java_import org.newdawn.slick.geom.Line
java_import org.newdawn.slick.util.Log # supports info, debug, warn, and error

require 'game'
require 'logger'

$logger = Logger.new(STDERR) # or ("log.txt")
$logger.level = Logger::DEBUG

game = Game.new('SteeringBehaviorDemo')
game.run
