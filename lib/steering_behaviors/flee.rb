##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Flee

  # Flee a specific position via the best possible route.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +kinematic+ -> the thing that is fleeing
  #   - +flee_position+ -> the position-vector that we want to flee from
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, flee_position)
    best_velocity_to_target = (kinematic.position_vec - flee_position).normalize * kinematic.max_speed
    best_velocity_to_target - kinematic.velocity_vec
  end
end
