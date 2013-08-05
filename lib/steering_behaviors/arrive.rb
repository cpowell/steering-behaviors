##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Arrive
  TARGET_RADIUS=0

  # Arrive 'gently' at the goal position by decelerating smoothly.
  #
  # * *Args*    :
  #   - +kinematic+ -> the thing that is moving and arriving
  #   - +goal_position+ -> a Vector of position
  #   - +slow_radius+ -> don't begin decelerating until inside this radius; max speed outside
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(kinematic, goal_position, slow_radius=200)
    to_target = goal_position - kinematic.position_vec
    dist = to_target.length

    if dist < TARGET_RADIUS
      return SteeringBehaviors::Vector.new(0,0)
    elsif dist > slow_radius
      desired_speed = kinematic.max_speed
    else
      desired_speed = kinematic.max_speed * dist / slow_radius
    end

    desired_vel = to_target.normalize * desired_speed

    return desired_vel - kinematic.velocity_vec
  end
end
