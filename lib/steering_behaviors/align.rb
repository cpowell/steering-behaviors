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
  def self.steer(hunter_kinematic, quarry_kinematic)
    hunter_heading = hunter_kinematic.heading_vec
    quarry_heading = quarry_kinematic.heading_vec

    rot_diff = hunter_heading.radians - quarry_heading.radians
    difference = ( ( quarry_heading.radians - hunter_heading.radians + 3*Math::PI ) % (2*Math::PI) ) - Math::PI

    turn_rate =  0.2
    turn_rate *= (difference < 0 ? -1 : 1) # Left or right

    # Place the target
    if turn_rate.abs > 0
      target_local = SteeringBehaviors::Vector.new(Math.sin(turn_rate), Math.cos(turn_rate))
    else
      target_local = SteeringBehaviors::Vector.new(0, 1.0)
    end

    target_local.rotate!(hunter_kinematic.heading_vec.radians)
    target_local * hunter_kinematic.speed
  end


end
