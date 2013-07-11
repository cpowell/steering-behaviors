class SteeringBehaviors::Flee
  # Flee a specific position via the best possible route.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +flee_position+ -> the position-vector that we want to flee from
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, flee_position)
    best_velocity_to_target = (kinematic.position_vec - flee_position).normalize * kinematic.max_speed
    best_velocity_to_target - kinematic.velocity_vec
  end
end
