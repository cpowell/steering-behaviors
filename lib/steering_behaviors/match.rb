##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Match

  # Matches the target's course and speed.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> my moving thing
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   - the steering force
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    desired_velocity = quarry_kinematic.heading_vec * quarry_kinematic.velocity_vec.length

    return desired_velocity - hunter_kinematic.velocity_vec
  end

end
