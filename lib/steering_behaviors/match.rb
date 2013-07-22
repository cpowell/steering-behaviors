class SteeringBehaviors::Match

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  #   - +alignment_threshold+ -> consider aligned if the difference < this val
  # * *Returns* :
  #   -
  # * *Raises* :
  #   - ++ ->
  #
  def self.steer(hunter_kinematic, quarry_kinematic, alignment_threshold)
    course_diff = ( ( quarry_kinematic.heading_vec.radians - hunter_kinematic.heading_vec.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    puts course_diff

    speed_diff = quarry_kinematic.speed - hunter_kinematic.speed

    return SteeringBehaviors::Vector.new(0,0) if course_diff.abs <= alignment_threshold

    target_local = SteeringBehaviors::Vector.new(course_diff * 20, speed_diff)

    target_local.rotate!(hunter_kinematic.heading_vec.radians)
  end

end
