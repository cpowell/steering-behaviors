class SteeringBehaviors::Evade
  # Pursue a moving target by anticipating its future position. Calculates where it thinks
  # the target will be, and leverages 'seek' to calculate how to get there.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, target_position_vec, target_velocity_vec)
    offset          = target_position_vec - kinematic.position_vec # relative (dx, dy) vector to quarry
    direct_distance = offset.length
    unit_offset     = offset / direct_distance

    parallelness = kinematic.heading_vec.dot(target_velocity_vec.normalize)
    forwardness  = unit_offset.dot(kinematic.heading_vec)

    f = self.interval_comparison(forwardness,  -0.707, 0.707)
    p = self.interval_comparison(parallelness, -0.707, 0.707)

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

    direct_travel_time     = direct_distance / kinematic.speed
    direct_travel_time_2   = direct_distance / (kinematic.speed + target_velocity_vec.length)
    estimated_time_enroute = direct_travel_time_2 * tf

    # printf "#{ipos.entity}'s target #{qpos.entity} is '#{gen}'. fness: %0.3f pness: %0.3f f: %0.3f p: %0.3f tf: %0.3f\n", forwardness, parallelness, f, p, tf
    predicted_pos_vec = target_position_vec + (target_velocity_vec * estimated_time_enroute)

    return [predicted_pos_vec, SteeringBehaviors::Flee.steer(kinematic, predicted_pos_vec)]
  end

  #=============================================================
  private

  def self.interval_comparison(x, lower_bound, upper_bound)
    return -1 if x < lower_bound
    return 1 if x > upper_bound
    return 0
  end
end
