class SteeringBehaviors::Align

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   -
  #
  def self.steer(hunter_kinematic, quarry_kinematic)
    course_diff = ( ( quarry_kinematic.heading_vec.radians - hunter_kinematic.heading_vec.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    target_local = SteeringBehaviors::Vector.new(course_diff * hunter_kinematic.speed, 0)
    target_local.rotate!(hunter_kinematic.heading_vec.radians)
  end

end
