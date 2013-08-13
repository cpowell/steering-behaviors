##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Evade
  extend SteeringBehaviors::Common

  # Evade a moving target by anticipating its future position. Our character calculates
  # where it thinks the enemy will be, and leverages 'flee' to calculate how to best escape.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and evading
  #   - +enemy_kinematic+ -> kinematic of the thing to evade
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, enemy_kinematic)
    offset          = enemy_kinematic.position_vec - character_kinematic.position_vec
    direct_distance = offset.length
    unit_offset     = offset / direct_distance

    parallelness = character_kinematic.heading_vec.dot(enemy_kinematic.heading_vec)
    forwardness  = unit_offset.dot(character_kinematic.heading_vec)

    gen, tf = compute_time_factor(forwardness, parallelness)

    direct_travel_time     = direct_distance / character_kinematic.speed
    direct_travel_time_2   = direct_distance / (character_kinematic.speed + enemy_kinematic.speed)
    estimated_time_enroute = direct_travel_time_2 * tf

    # printf "#{ipos.entity}'s target #{qpos.entity} is '#{gen}'. fness: %0.3f pness: %0.3f f: %0.3f p: %0.3f tf: %0.3f\n", forwardness, parallelness, f, p, tf
    predicted_pos_vec = enemy_kinematic.position_vec + (enemy_kinematic.velocity_vec * estimated_time_enroute)

    return [predicted_pos_vec, SteeringBehaviors::Flee.steer(character_kinematic, predicted_pos_vec)]
  end

end
