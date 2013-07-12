require 'common'

class SteeringBehaviors::Pursue
  extend SteeringBehaviors::Common

  # Pursue a moving target by anticipating its future position. Calculates where it thinks
  # the target will be, and leverages 'seek' to calculate how to get there.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   -
  # * *Raises* :
  #   - ++ ->
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    offset          = quarry_kinematic.position_vec - hunter_kinematic.position_vec
    direct_distance = offset.length
    unit_offset     = offset / direct_distance

    parallelness = hunter_kinematic.heading_vec.dot(quarry_kinematic.heading_vec)
    forwardness  = unit_offset.dot(hunter_kinematic.heading_vec)

    gen, tf = compute_time_factor(forwardness, parallelness)

    direct_travel_time     = direct_distance / hunter_kinematic.speed
    direct_travel_time_2   = direct_distance / (hunter_kinematic.speed + quarry_kinematic.speed)
    estimated_time_enroute = direct_travel_time_2 * tf

    # printf "#{ipos.entity}'s target #{qpos.entity} is '#{gen}'. fness: %0.3f pness: %0.3f f: %0.3f p: %0.3f tf: %0.3f\n", forwardness, parallelness, f, p, tf
    predicted_pos_vec = quarry_kinematic.position_vec + (quarry_kinematic.velocity_vec * estimated_time_enroute)

    return [predicted_pos_vec, SteeringBehaviors::Seek.steer(hunter_kinematic, predicted_pos_vec)]
  end


end
