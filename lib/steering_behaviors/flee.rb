##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Flee

  # Flee a specific position via the best possible route.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and fleeing
  #   - +flee_position+ -> the position-vector that we want to flee from
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(character_kinematic, flee_position)
    desired_velocity = (character_kinematic.position_vec - flee_position).normalize * character_kinematic.max_speed
    force = (desired_velocity - character_kinematic.velocity_vec)
  end
end
