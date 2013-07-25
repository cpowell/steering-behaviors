##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Arrive

  # Arrive 'gently' at the goal position by decelerating smoothly.
  #
  # * *Args*    :
  #   - +kinematic+ -> the thing that is moving and arriving
  #   - +goal_position+ -> a Vector of position
  #   - +gentleness+ -> higher values will make the arrival more gradual and 'gentle'
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(kinematic, goal_position, gentleness=0.8)
    to_target = goal_position - kinematic.position_vec
    dist = to_target.length

    if dist > 0
      desired_speed = dist / gentleness
      desired_speed = [desired_speed, kinematic.max_speed].min

      desired_velocity = to_target.normalize * desired_speed
      return desired_velocity - kinematic.velocity_vec
    else
      return SteeringBehaviors::Vector.new(0,0)
    end
  end
end
