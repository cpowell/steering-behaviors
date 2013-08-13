##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Align

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and aligning
  #   - +other_kinematic+ -> kinematic of the thing to align with
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, other_kinematic)
    desired_velocity = other_kinematic.heading_vec * character_kinematic.velocity_vec.length

    return desired_velocity - character_kinematic.velocity_vec
  end

end
