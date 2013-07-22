class SteeringBehaviors::Align

  # Align with a moving target by observing its course.
  #
  # * *Args*    :
  #   - +hunter_kinematic+ -> pursuing kinematic
  #   - +quarry_kinematic+ -> kinematic of the target
  # * *Returns* :
  #   -
  # * *Raises* :
  #   - ++ ->
  #
  def self.steer(hunter_kinematic, quarry_kinematic, alignment_threshold, multiplier=8 )
    difference = ( ( quarry_kinematic.heading_vec.radians - hunter_kinematic.heading_vec.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    return SteeringBehaviors::Vector.new(0,0) if difference.abs <= alignment_threshold

    if difference > 0
      target_local = SteeringBehaviors::Vector.new(multiplier, 0)
    else
      target_local = SteeringBehaviors::Vector.new(-multiplier, 0)
    end

    target_local.rotate!(hunter_kinematic.heading_vec.radians)
  end

end
