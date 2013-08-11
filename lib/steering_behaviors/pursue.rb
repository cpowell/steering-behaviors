##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Pursue
  extend SteeringBehaviors::Common

  # Pursue a moving target by anticipating its future position. Calculates where it thinks
  # the target will be, and leverages 'seek' to calculate how to get there.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and pursuing
  #   - +other_kinematic+ -> kinematic of the thing to pursue
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, other_kinematic)
    offset          = other_kinematic.position_vec - character_kinematic.position_vec
    direct_distance = offset.length
    unit_offset     = offset / direct_distance

    parallelness = character_kinematic.heading_vec.dot(other_kinematic.heading_vec)
    forwardness  = unit_offset.dot(character_kinematic.heading_vec)

    gen, tf = compute_time_factor(forwardness, parallelness)

    direct_travel_time     = direct_distance / character_kinematic.speed
    direct_travel_time_2   = direct_distance / (character_kinematic.speed + other_kinematic.speed)
    estimated_time_enroute = direct_travel_time_2 * tf
    # printf "#{ipos.entity}'s target #{qpos.entity} is '#{gen}'. fness: %0.3f pness: %0.3f f: %0.3f p: %0.3f tf: %0.3f\n", forwardness, parallelness, f, p, tf
    predicted_pos_vec = other_kinematic.position_vec + (other_kinematic.velocity_vec * estimated_time_enroute)

    # puts "#{compute_nearest_approach_distance(character_kinematic, other_kinematic)} in #{compute_nearest_approach_time(character_kinematic, other_kinematic)} sec"
    return [predicted_pos_vec, SteeringBehaviors::Seek.steer(character_kinematic, predicted_pos_vec)]
  end


end
