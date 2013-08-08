##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Separation
  DECAY_COEFF = 10000

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our character"
  #   - +other_kinematic+ -> kinematic of the thing we want to separate from
  # * *Returns* :
  #   -
  #
  def self.steer(character_kinematic, other_kinematic, threshold)
    direction = (character_kinematic.position_vec - other_kinematic.position_vec)
    dist = direction.length
    if dist < threshold
      strength = DECAY_COEFF * 1 / (dist * dist)
      puts strength

      direction.normalize!
      return direction*strength
    end

    return SteeringBehaviors::Vector.new(0,0)
  end

end
