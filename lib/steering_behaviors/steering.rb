##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Steering

  # Given a steering force vector, alter course and velocity accordingly.
  # Takes turn rate limitations, mass, and other limits into account, and
  # directly alters the provided Mobile component.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> "our" character that is moving
  #   - +steering_force+ -> force vector supplied by a steering behavior
  #   - +delta+ -> time delta (in seconds) used for scaling the result
  #
  def self.feel_the_force(character_kinematic, steering_force, delta, accelerative=true)
    return if steering_force.nil?

    acceleration = steering_force / character_kinematic.mass

    # Compute the new, proposed velocity vector.
    desired_velocity = character_kinematic.velocity_vec + (acceleration * delta)
    desired_velocity.truncate!(character_kinematic.speed) if !accelerative
    desired_velocity.truncate!(character_kinematic.max_speed)

    # If this timeslice's proposed velocity-vector exceeds the turn rate,
    # come up with a revised velociy-vec that doesn't exceed the rate -- and use that.
    angle             = Math.acos character_kinematic.heading_vec.dot(desired_velocity.normalize)
    max_course_change = character_kinematic.max_turn * delta

    if angle.abs > max_course_change
      direction    = SteeringBehaviors::Vector.sign(character_kinematic.velocity_vec, desired_velocity) # -1==CCW, 1==CW
      limited_crse = character_kinematic.heading_vec.radians - max_course_change * direction

      # printf "Current %0.4f. Angle %0.4f %s exceeds max change %0.4f. Desired course [%0.4f], limited course [%0.4f]\n",
      #   character_kinematic.heading_vec.radians,
      #   angle,
      #   (direction==1 ? 'CW' : 'CCW'),
      #   max_course_change,
      #   desired_velocity.radians,
      #   limited_crse

      character_kinematic.velocity_vec = SteeringBehaviors::Vector.new(
        Math.sin(limited_crse) * character_kinematic.speed,
        Math.cos(limited_crse) * character_kinematic.speed
      )
    else
      character_kinematic.velocity_vec = desired_velocity
    end
  end

end
