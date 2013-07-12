require 'common'

class SteeringBehaviors::Evade
  extend SteeringBehaviors::Common

  # Evade a moving target by anticipating its future position. Calculates where it thinks
  # the target will be, and leverages 'flee' to calculate how to best escape.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +evading_kinematic+ -> evading kinematic
  #   - +enemy_kinematic+ -> kinematic of the thing to evade
  # * *Returns* :
  #   -
  # * *Raises* :
  #   - ++ ->
  #
  def self.steer(evading_kinematic, enemy_kinematic)
    offset          = enemy_kinematic.position_vec - evading_kinematic.position_vec
    direct_distance = offset.length
    unit_offset     = offset / direct_distance

    parallelness = evading_kinematic.heading_vec.dot(enemy_kinematic.heading_vec)
    forwardness  = unit_offset.dot(evading_kinematic.heading_vec)

    gen, tf = compute_time_factor(forwardness, parallelness)

    direct_travel_time     = direct_distance / evading_kinematic.speed
    direct_travel_time_2   = direct_distance / (evading_kinematic.speed + enemy_kinematic.speed)
    estimated_time_enroute = direct_travel_time_2 * tf

    # printf "#{ipos.entity}'s target #{qpos.entity} is '#{gen}'. fness: %0.3f pness: %0.3f f: %0.3f p: %0.3f tf: %0.3f\n", forwardness, parallelness, f, p, tf
    predicted_pos_vec = enemy_kinematic.position_vec + (enemy_kinematic.velocity_vec * estimated_time_enroute)

    return [predicted_pos_vec, SteeringBehaviors::Flee.steer(evading_kinematic, predicted_pos_vec)]
  end

end
