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

  # Flee a specific position via the best possible route.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +target_position_vector+ -> the position-vector where we want to go
  # * *Returns* :
  #   - the calculated steering force
  #
  def flee(target_position_vector)
    best_velocity_to_target = (self.position_vec - target_position_vector).normalize * self.max_speed
    best_velocity_to_target - self.velocity_vec
  end

  # Pursue a moving target by anticipating its future position. Calculates where it thinks
  # the target will be, and leverages 'seek' to calculate how to get there.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +ipos+ -> the "interceptor"'s Position component
  #   - +imob+ -> the "interceptor"'s Mobile component
  #   - +qpos+ -> the "quarry"'s Position component
  #   - +qmob+ -> the "quarry"'s Mobile componeont
  # * *Returns* :
  #   - the calculated steering force
  #
  def pursue(target_position_vec, target_velocity_vec)
    offset          = target_position_vec - self.position_vec # relative (dx, dy) vector to quarry
    direct_distance = offset.length
    unit_offset     = offset / direct_distance

    parallelness = self.heading_vec.dot(target_velocity_vec.normalize)
    forwardness  = unit_offset.dot(self.heading_vec)

    f = interval_comparison(forwardness,  -0.707, 0.707)
    p = interval_comparison(parallelness, -0.707, 0.707)

    # Break the pursuit into nine cases, the cross product of the
    # quarry being [ahead, aside, or behind] us and heading
    # [parallel, perpendicular, or anti-parallel] to us.
    case f
    when 1
      case p
      when 1
        gen="ahead, parallel"
        tf = 1.8
      when 0
        gen="ahead, perpendicular"
        tf = 1.35
      when -1
        gen="ahead, anti-parallel"
        tf = 1.10
      end
    when 0
      case p
      when 1
        gen="aside, parallel"
        tf = 1.20
      when 0
        gen="aside, perpedicular"
        tf = 1.20
      when -1
        gen="aside, anti-parallel"
        tf = 1.20
      end
    when -1
      case p
      when 1
        gen="behind, parallel"
        tf = 1.20
      when 0
        gen="behind, perpendicular"
        tf = 1.20
      when -1
        gen="behind, anti-parallel"
        tf = 1.20
      end
    end

    direct_travel_time     = direct_distance / self.speed
    direct_travel_time_2   = direct_distance / (self.speed + target_velocity_vec.length)
    estimated_time_enroute = direct_travel_time_2 * tf

    # printf "#{ipos.entity}'s target #{qpos.entity} is '#{gen}'. fness: %0.3f pness: %0.3f f: %0.3f p: %0.3f tf: %0.3f\n", forwardness, parallelness, f, p, tf
    predicted_pos_vec = target_position_vec + (target_velocity_vec * estimated_time_enroute)

    return [predicted_pos_vec, seek(predicted_pos_vec)]
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


  #=============================================================
  private

  def interval_comparison(x, lower_bound, upper_bound)
    return -1 if x < lower_bound
    return 1 if x > upper_bound
    return 0
  end
end
