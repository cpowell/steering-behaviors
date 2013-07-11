class SteeringBehaviors::Seek

  # Seek a specific position; unlike 'arrive', will not slow down to stop at that pos.
  # See http://www.red3d.com/cwr/steer/
  #
  # * *Args*    :
  #   - +kinematic+ ->
  #   - +goal_position+ -> the position-vector where we want to go
  # * *Returns* :
  #   - the calculated steering force
  #
  def self.steer(kinematic, goal_position)
    desired_velocity = (goal_position - kinematic.position_vec).normalize * kinematic.max_speed
    desired_velocity - kinematic.velocity_vec
  end
end
