class SteeringBehaviors::Wander
  # Wander about in a 'random walk' way. Speeds up and slows down, too.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - ++ -> how erratic the wandering effect will be
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, erraticism)
    kinematic.steering_target += SteeringBehaviors::Vector.new(rand(-1.0..1.0)*erraticism, rand(-1.0..1.0)*erraticism)
    kinematic.steering_target.normalize!

    kinematic.steering_target.rotate(kinematic.heading_vec.radians)
  end
end
