##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Orthogonal

  # Moves at a 90-degree angle to the target's course.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving
  #   - +other_kinematic+ -> kinematic of the thing to match
  # * *Returns* :
  #   - a steering force
  #
  def self.steer(character_kinematic, other_kinematic)
    option_a = SteeringBehaviors::Vector.new(other_kinematic.heading_vec.y, -other_kinematic.heading_vec.x)
    option_b = SteeringBehaviors::Vector.new(-other_kinematic.heading_vec.y, other_kinematic.heading_vec.x)

    da = option_a.delta(character_kinematic.heading_vec)
    db = option_b.delta(character_kinematic.heading_vec)

    best_hdg_vec = (da < db ? option_a : option_b)

    desired_velocity = best_hdg_vec * character_kinematic.velocity_vec.length

    return desired_velocity - character_kinematic.velocity_vec
  end

end
