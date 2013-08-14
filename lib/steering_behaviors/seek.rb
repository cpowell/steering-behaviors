##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Seek

  # Seek a specific position; unlike 'arrive', will not slow down to stop at that pos.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and seeking
  #   - +goal_position+ -> the position-vector that we want to seek
  # * *Returns* :
  #   - the steering force
  #
  def self.steer(character_kinematic, goal_position)
    desired_velocity = (goal_position - character_kinematic.position_vec).normalize * character_kinematic.max_speed
    desired_velocity - character_kinematic.velocity_vec
  end
end
