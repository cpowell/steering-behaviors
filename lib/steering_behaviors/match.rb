##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Match

  # Matches the target's course and speed.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and matching
  #   - +other_kinematic+ -> kinematic of the thing to match
  # * *Returns* :
  #   - the steering force
  #
  def self.steer(character_kinematic, other_kinematic)
    desired_velocity = other_kinematic.heading_vec * other_kinematic.velocity_vec.length

    return desired_velocity - character_kinematic.velocity_vec
  end

end
