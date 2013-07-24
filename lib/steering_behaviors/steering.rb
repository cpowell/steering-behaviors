class SteeringBehaviors::Steering

  # Given a steering force vector, alter course and velocity accordingly.
  # Takes turn rate limitations, mass, and other limits into account, and
  # directly alters the provided Mobile component.
  #
  # * *Args*    :
  #   - +kinematic+ -> the kinematic thing
  #   - +steering_force+ -> force vector supplied by a steering behavior
  #   - +delta+ -> time delta (in seconds) used for scaling the result
  #   - +accelerative+ -> whether you want the steering to change the thing's velocity (default true)
  #
  def self.feel_the_force(kinematic, steering_force, delta, accelerative=true) #, mobile, position)
    acceleration = steering_force / kinematic.mass

    # Compute the new, proposed velocity vector.
    desired_velocity = kinematic.velocity_vec + (acceleration * delta)

    desired_velocity.truncate!(kinematic.speed) if !accelerative
    desired_velocity.truncate!(kinematic.max_speed)

    # If this timeslice's proposed velocity-vector exceeds the turn rate,
    # come up with a revised velociy-vec that doesn't exceed the rate -- and use that.
    angle             = Math.acos kinematic.heading_vec.dot(desired_velocity.normalize)
    max_course_change = kinematic.max_turn * delta

    if angle.abs > max_course_change
      direction    = SteeringBehaviors::Vector.sign(kinematic.velocity_vec, desired_velocity) # -1==CCW, 1==CW
      limited_crse = kinematic.heading_vec.radians - max_course_change * direction

      # printf "Current %0.4f. Angle %0.4f %s exceeds max change %0.4f. Desired course [%0.4f], limited course [%0.4f]\n",
      #   kinematic.heading_vec.radians,
      #   angle,
      #   (direction==1 ? 'CW' : 'CCW'),
      #   max_course_change,
      #   desired_velocity.radians,
      #   limited_crse

      kinematic.velocity_vec = SteeringBehaviors::Vector.new(
        Math.sin(limited_crse) * kinematic.speed,
        Math.cos(limited_crse) * kinematic.speed
      )
    else
      kinematic.velocity_vec = desired_velocity
    end
  end

end
