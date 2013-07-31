##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Broadside

  # Always face one's side (i.e. a ship's broadside) to the target. Can be used for
  # exposing weapons, orbiting, etc.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    to_quarry = (quarry_kinematic.position_vec - hunter_kinematic.position_vec).normalize
    option_a = SteeringBehaviors::Vector.new(to_quarry.y, -to_quarry.x)
    option_b = SteeringBehaviors::Vector.new(-to_quarry.y, to_quarry.x)

    da = option_a.delta(hunter_kinematic.heading_vec)
    db = option_b.delta(hunter_kinematic.heading_vec)

    best_hdg_vec = (da < db ? option_a : option_b)

    desired_velocity = best_hdg_vec.normalize * hunter_kinematic.velocity_vec.length

    return desired_velocity - hunter_kinematic.velocity_vec
  end

end
