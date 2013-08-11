##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Separation
  extend SteeringBehaviors::Common

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and separating
  #   - +other_kinematic+ -> kinematic of the thing to separate from
  #   - +danger_radius+ -> attempt to avoid closest approach of less than this value
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, other_kinematic, danger_radius)
    cpa_time, char_pos_vec, other_pos_vec = compute_nearest_approach_positions(character_kinematic, other_kinematic)

    return SteeringBehaviors::VEC_ZERO if cpa_time < 0
    cpa_dist = (char_pos_vec - other_pos_vec).length
    return SteeringBehaviors::VEC_ZERO if cpa_dist > danger_radius

    parallelness = character_kinematic.heading_vec.dot(other_kinematic.heading_vec)

    side_vec = character_kinematic.heading_vec.perpendicular
    val = 0

    if parallelness < -0.707
      # anti-parallel, head-on paths
      # steer away from the threat's future posn
      offset_vec = other_pos_vec - character_kinematic.position_vec
      side_dot = offset_vec.dot(side_vec)
      val = (side_dot > 0 ? -1.0 : 1.0)
      # puts "Head-on, steering away from future pos"
    elsif parallelness > 0.707
      # parallel paths; steer away from threat
      offset_vec = other_kinematic.position_vec - character_kinematic.position_vec
      side_dot = offset_vec.dot(side_vec)
      val = (side_dot > 0 ? -1.0 : 1.0)
      # puts "Parallel, steering away from other guy"
    else
      # perpendicular paths; steer behind threat
      if other_kinematic.speed <= character_kinematic.speed
        side_dot = side_vec.dot(other_kinematic.velocity_vec)
        val = (side_dot > 0 ? -1.0 : 1.0)
        # puts "Perpendicular, steering behind other guy"
      end
    end

    return side_vec * val

  end

end
