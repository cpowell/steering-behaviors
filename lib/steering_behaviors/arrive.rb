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
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and arriving
  #   - +goal_position+ -> a Vector of position at which to arrive
  #   - +slow_radius+ -> don't begin decelerating until inside this radius; maintain max speed outside
  #   - +arrive_radius+ -> consider ourselves 'arrived' when inside this radius
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, goal_position, slow_radius, arrive_radius=0)
    to_target = goal_position - character_kinematic.position_vec
    dist = to_target.length

    if dist < arrive_radius
      return SteeringBehaviors::VEC_ZERO
    elsif dist > slow_radius
      desired_speed = character_kinematic.max_speed
    else
      desired_speed = character_kinematic.max_speed * dist / slow_radius
    end

    desired_vel = to_target.normalize * desired_speed

    return desired_vel - character_kinematic.velocity_vec
  end
end
