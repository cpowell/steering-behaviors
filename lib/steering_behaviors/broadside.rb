class SteeringBehaviors::Broadside

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   -
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    desired_velocity = (quarry_kinematic.position_vec - hunter_kinematic.position_vec).normalize * hunter_kinematic.max_speed

    a = desired_velocity.rotate(Math::PI/2)
    b = desired_velocity.rotate(-Math::PI/2)

    diff_a = hunter_kinematic.heading_vec.radians - a.radians
    diff_b = hunter_kinematic.heading_vec.radians - b.radians

    (diff_a < diff_b ? a : b)
  end

end
