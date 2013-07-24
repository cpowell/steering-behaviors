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
    to_quarry = (quarry_kinematic.position_vec - hunter_kinematic.position_vec).normalize
    option_a = to_quarry.rotate(Math::PI/2)
    option_b = to_quarry.rotate(Math::PI/2*3)

    da = option_a.delta(hunter_kinematic.heading_vec)
    db = option_b.delta(hunter_kinematic.heading_vec)
    # puts "Da #{da}, Db #{db}"

    best_hdg_vec = (da < db ? option_a : option_b)

    desired_velocity = best_hdg_vec * hunter_kinematic.speed
  end

end
