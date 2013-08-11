##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Separation
  extend SteeringBehaviors::Common

  # Steer to avoid another kinematic by a certain radius.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and separating
  #   - +other_kinematic+ -> kinematic of the thing to separate from
  #   - +danger_radius+ -> attempt to avoid closest approach of less than this value
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, other_kinematic, danger_radius)
    cpa_time, char_pos_at_cpa, other_pos_at_cpa = compute_nearest_approach(character_kinematic, other_kinematic)

    # Do nothing if the CPA is in the past, or if we won't breach the danger radius
    return SteeringBehaviors::VEC_ZERO if cpa_time < 0
    cpa_dist = (char_pos_at_cpa - other_pos_at_cpa).length
    return SteeringBehaviors::VEC_ZERO if cpa_dist > danger_radius

    offset_vec  = other_kinematic.position_vec - character_kinematic.position_vec
    unit_offset = offset_vec.normalize
    forwardness = unit_offset.dot(character_kinematic.heading_vec)
    parallelness = character_kinematic.heading_vec.dot(other_kinematic.heading_vec)

    side_vec = character_kinematic.heading_vec.perpendicular

    if parallelness < -0.707
      # anti-parallel, head-on paths; steer away from the threat's future pos
      puts "Head-on, steering away from future pos"
      offset_vec = other_pos_at_cpa - character_kinematic.position_vec
      side_dot = offset_vec.dot(side_vec)
    elsif parallelness > 0.707
      # parallel paths; steer away from threat
      puts "Parallel, steering away from other guy"
      side_dot = offset_vec.dot(side_vec)
    else
      # perpendicular paths; steer behind threat
      side_dot = other_kinematic.velocity_vec.dot(side_vec)
      if forwardness < 0.707
        puts "Perpendicular, steering ahead of other guy"
        side_dot *= -1
      else
        puts "Perpendicular, steering behind other guy"
      end
    end

    val = (side_dot > 0 ? -1.0 : 1.0)

    return side_vec * val

  end

end
