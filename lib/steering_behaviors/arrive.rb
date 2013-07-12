class SteeringBehaviors::Arrive
  #
  #
  # * *Args*    :
  #   - ++ ->
  #   - +gentleness+ -> higher values will make the arrival more gradual and 'gentle'
  # * *Returns* :
  #   -
  # * *Raises* :
  #   - ++ ->
  #
  def self.steer(kinematic, goal_position, gentleness=0.8)
    to_target = goal_position - kinematic.position_vec
    dist = to_target.length

    if dist > 0
      desired_speed = dist / gentleness
      desired_speed = [desired_speed, kinematic.max_speed].min

      desired_velocity = to_target.normalize * desired_speed
      return desired_velocity - kinematic.velocity_vec
    else
      return SteeringBehaviors::Vector.new(0,0)
    end
  end
end
