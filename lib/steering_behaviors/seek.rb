##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Seek

  # Seek a specific position; unlike 'arrive', will not slow down to stop at that pos.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +kinematic+ -> my seeking thing
  #   - +goal_position+ -> the position-vector where we want to go
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, goal_position)
    desired_velocity = (goal_position - kinematic.position_vec).normalize * kinematic.max_speed
    desired_velocity - kinematic.velocity_vec
  end
end
