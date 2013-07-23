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
    option_b = to_quarry.rotate(-Math::PI/2)

    course_diff_a = ( ( quarry_kinematic.heading_vec.radians - option_a.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI
    course_diff_b = ( ( quarry_kinematic.heading_vec.radians - option_b.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    desired = (course_diff_a < course_diff_b ? option_a : option_b)

    desired * 20
  end

end
