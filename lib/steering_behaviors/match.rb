##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Match

  # Matches the target's course and speed.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> my moving thing
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   - the steering force
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    course_diff = ( ( quarry_kinematic.heading_vec.radians - hunter_kinematic.heading_vec.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    speed_diff = quarry_kinematic.speed - hunter_kinematic.speed

    target_local = SteeringBehaviors::Vector.new(course_diff * quarry_kinematic.speed, speed_diff)
    target_local.rotate!(hunter_kinematic.heading_vec.radians)
  end

end
