##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the library.

class SteeringBehaviors::Wander

  # Wander about in a 'random walk' way. Speeds up and slows down, too.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving and wandering
  #   - +erraticism+ -> how erratic the wandering effect will be
  # * *Returns* :
  #   - the steering force
  #
  def self.steer(character_kinematic, erraticism)
    character_kinematic.steering_target += SteeringBehaviors::Vector.new(rand(-1.0..1.0)*erraticism, rand(-1.0..1.0)*erraticism)
    character_kinematic.steering_target.normalize!

    character_kinematic.steering_target.rotate(character_kinematic.heading_vec.radians)
  end
end
