##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Orthogonal

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   -
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    option_a = SteeringBehaviors::Vector.new(quarry_kinematic.heading_vec.y, -quarry_kinematic.heading_vec.x)
    option_b = SteeringBehaviors::Vector.new(-quarry_kinematic.heading_vec.y, quarry_kinematic.heading_vec.x)

    da = option_a.delta(hunter_kinematic.heading_vec)
    db = option_b.delta(hunter_kinematic.heading_vec)

    best_hdg_vec = (da < db ? option_a : option_b)

    desired_velocity = best_hdg_vec * hunter_kinematic.velocity_vec.length
  end

end
