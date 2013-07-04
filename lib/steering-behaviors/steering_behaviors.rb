module SteeringBehaviors
  # Wander about in a 'random walk' way. Speeds up and slows down, too.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - ++ -> how erratic the wandering effect will be
  # * *Returns* :
  #   - the calculated steering force
  #
  def wander(erraticism)
    self.steering_target += Vector.new(rand(-1.0..1.0)*erraticism, rand(-1.0..1.0)*erraticism)
    self.steering_target.normalize!

    self.steering_target.rotate(self.heading_vec.radians)
  end

  # Seek a specific position; unlike 'arrive', will not slow down to stop at that pos.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +target_position_vector+ -> the position-vector where we want to go
  # * *Returns* :
  #   - the calculated steering force
  #
  def seek(target_position_vector)
    best_velocity_to_target = (target_position_vector - self.position_vec).normalize * self.max_speed
    best_velocity_to_target - self.velocity_vec
  end

  # Given a steering force vector, alter course and velocity accordingly.
  # Takes turn rate limitations, mass, and other limits into account, and
  # directly alters the provided Mobile component.
  #
  # * *Args*    :
  #   - +steering_force+ -> force vector supplied by a steering behavior
  #   - +delta+ -> time delta (in seconds) used for scaling the result
  #
  def feel_the_force(steering_force, delta) #, mobile, position)
    max_course_change = self.max_turn * delta # radians per sec

    acceleration = steering_force / self.mass

    # Compute the new, proposed velocity vector.
    proposed_velocity_vec = self.velocity_vec + (acceleration * delta) * self.maneuverability

    # If this timeslice's proposed velocity-vector exceeds the turn rate,
    # come up with a revised velociy-vec that doesn't exceed the rate -- and use that.
    course_change = Math.acos(self.heading_vec.dot(proposed_velocity_vec.normalize))

    if course_change.abs > max_course_change
      direction    = Vector.sign(self.velocity_vec, proposed_velocity_vec) # 1==CCW, -1==CW
      limited_crse = self.heading_vec.radians - max_course_change * direction

      self.velocity_vec = Vector.new(Math.sin(limited_crse) * proposed_velocity_vec.length, Math.cos(limited_crse) * proposed_velocity_vec.length)

      # printf "Desired course change %0.4f %s exceeds %0.4f allowable. Curr course [%0.4f], desired course [%0.4f], limited course [%0.4f]\n", course_change, (direction==-1 ? 'clockwise' : 'counter-clockwise'), max_course_change, self.heading_vec.radians, proposed_velocity_vec.radians, limited_crse
    else
      self.velocity_vec = proposed_velocity_vec
    end
  end
end
