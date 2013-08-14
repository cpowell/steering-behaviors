##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class Bug
  attr_reader :mass, :heading_vec, :velocity_vec, :position_vec
  attr_accessor :min_speed, :max_speed, :max_turn
  attr_accessor :steering_target

  # The 'bug' is the little moving creature that steers on-screen.
  #
  # * *Args*    :
  #   - +x+ -> starting X pos
  #   - +y+ -> starting Y pos
  #   - +course+ -> course in true degrees (0 is north)
  #   - +speed+ -> speed
  #   - +mass+ -> mass of the thing (more mass means slower acceleration)
  #   - +max_turn+ -> max turn rate in rads per sec
  #   - +min_speed+ -> min speed
  #   - +max_speed+ -> max speed
  #
  def initialize(x, y, course, speed, mass, max_turn, min_speed, max_speed)
    super()

    @position_vec = SteeringBehaviors::Vector.new(x, y) # A non-normalized vector holding X,Y position

    @mass      = mass
    @max_turn  = max_turn
    @min_speed = min_speed
    @max_speed = max_speed

    @steering_target = SteeringBehaviors::Vector.new(0, 1.0) # relative to me; i.e. straight ahead

    # We could, in theory, handle 'pointing in one direction while moving in another.'
    # (Think of the spaceship in _Asteroids_, or "strafing" in a shooter.)

    @velocity_vec = SteeringBehaviors::Vector.new # A non-normalized vector implying direction AND speed.
    @velocity_vec.x = speed * Math.sin(SteeringBehaviors::Vector.deg2rad(course))
    @velocity_vec.y = speed * Math.cos(SteeringBehaviors::Vector.deg2rad(course))

    @heading_vec = @velocity_vec.normalize
  end

  def velocity_vec=(new_vec)
    @velocity_vec = new_vec
    @velocity_vec.truncate!(@max_speed)

    @heading_vec = @velocity_vec.normalize

    if @velocity_vec.length < @min_speed
      @velocity_vec.normalize!
      @velocity_vec *= @min_speed
    end
  end

  def speed
    @velocity_vec.length
  end

  def course
    @heading_vec.radians
  end

  def move(delta)
    @position_vec += @velocity_vec * delta
  end

end
