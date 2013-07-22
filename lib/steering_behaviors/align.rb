class SteeringBehaviors::Align

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
    difference = ( ( quarry_kinematic.heading_vec.radians - hunter_kinematic.heading_vec.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    return SteeringBehaviors::Vector.new(0,0) if difference.abs <= alignment_threshold

    target_local = SteeringBehaviors::Vector.new(difference * hunter_kinematic.speed, 0)

    target_local.rotate!(hunter_kinematic.heading_vec.radians)
  end

end
