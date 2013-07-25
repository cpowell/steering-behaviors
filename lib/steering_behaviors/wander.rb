##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

class SteeringBehaviors::Wander

  # Wander about in a 'random walk' way. Speeds up and slows down, too.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +kinematic+ -> the wandering thing
  #   - +erraticism+ -> how erratic the wandering effect will be
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, erraticism)
    kinematic.steering_target += SteeringBehaviors::Vector.new(rand(-1.0..1.0)*erraticism, rand(-1.0..1.0)*erraticism)
    kinematic.steering_target.normalize!

    kinematic.steering_target.rotate(kinematic.heading_vec.radians)
  end
end
