class SteeringBehaviors::Match

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

    speed_diff = quarry_kinematic.speed - hunter_kinematic.speed

    target_local = SteeringBehaviors::Vector.new(course_diff * quarry_kinematic.speed, speed_diff)
    target_local.rotate!(hunter_kinematic.heading_vec.radians)
  end

end
