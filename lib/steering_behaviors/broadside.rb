##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Broadside

  # Always face one's side (i.e. a ship's broadside) to the target. Can be used for
  # exposing weapons, orbiting, etc.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and broadsiding
  #   - +other_kinematic+ -> kinematic of thing to broadside to
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, other_kinematic)
    to_quarry = (other_kinematic.position_vec - character_kinematic.position_vec).normalize
    option_a = SteeringBehaviors::Vector.new(to_quarry.y, -to_quarry.x)
    option_b = SteeringBehaviors::Vector.new(-to_quarry.y, to_quarry.x)

    da = option_a.delta(character_kinematic.heading_vec)
    db = option_b.delta(character_kinematic.heading_vec)

    best_hdg_vec = (da < db ? option_a : option_b)

    desired_velocity = best_hdg_vec.normalize * character_kinematic.velocity_vec.length

    return desired_velocity - character_kinematic.velocity_vec
  end

end
