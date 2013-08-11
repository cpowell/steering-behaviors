##
# Copyright 2013, Prylis Incorporated.
#
# This file is part of The Ruby Steering Behaviors Library.
# http://github.com/cpowell/steering-behaviors
# You can redistribute and/or modify this software only in accordance with
# the terms found in the "LICENSE" file included with the framework.

module SteeringBehaviors::Common

  # Given two kinematics, determine how many seconds until their Closest Point of Approach (CPA)
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving
  #   - +other_kinematic+ -> kinematic of the other mover
  # * *Returns* :
  #   - time in seconds until CPA; may be negative (for 'in the past')
  #
  def compute_nearest_approach_time(character_kinematic, other_kinematic)
    relative_vel_vec = other_kinematic.velocity_vec - character_kinematic.velocity_vec
    relative_speed = relative_vel_vec.length

    return 0 if relative_speed==0

    relative_tangent_vec = relative_vel_vec / relative_speed
    relative_position_vec = character_kinematic.position_vec - other_kinematic.position_vec

    projection = relative_tangent_vec.dot(relative_position_vec)
    return projection / relative_speed
  end

  # Given two kinematics, determine where they will be at the time of closest approach.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving
  #   - +other_kinematic+ -> kinematic of the other mover
  # * *Returns* :
  #   - a tuple consisting of (time until CPA), (character position at CPA), (other position at CPA)
  #
  def compute_nearest_approach(character_kinematic, other_kinematic)
    # How long until it happens?
    cpa_time = compute_nearest_approach_time(character_kinematic, other_kinematic)

    # How far will the two kinematics go in that time?
    char_travel_vec  = character_kinematic.velocity_vec * cpa_time
    other_travel_vec = other_kinematic.velocity_vec * cpa_time

    # Project forward from current positions...
    char_pos_vec = char_travel_vec + character_kinematic.position_vec
    other_pos_vec = other_travel_vec + other_kinematic.position_vec

    return [cpa_time, char_pos_vec, other_pos_vec]
  end

  # Given two kinematics, determine how close the two agents will be at their
  # time & place of closest approach. Largely a convenience method, since you
  # could call compute_nearest_approach() and do the same subtraction
  # just as easily.
  #
  # * *Args*    :
  #   - +character_kinematic+ -> kinematic of "our" character that is moving
  #   - +other_kinematic+ -> kinematic of the other mover
  # * *Returns* :
  #   - the distance between the two agents at their closest approach
  #
  def compute_nearest_approach_distance(character_kinematic, other_kinematic)
    cpa_time, char_pos_vec, other_pos_vec = compute_nearest_approach(character_kinematic, other_kinematic)

    (char_pos_vec - other_pos_vec).length
  end

  # A support routine used by Pursue and Evade. Observes how 'forward' the
  # target is, and how 'parallel' its course is to our own.
  #
  # * *Args*    :
  #   - +forwardness+ -> how forward a target is to the observer
  #   - +parallelness+ -> how parallel the target's course is to the observer's
  # * *Returns* :
  #   - array of [general language description, steering force]
  #
  def compute_time_factor(forwardness, parallelness)
    f = interval_comparison(forwardness,  -0.707, 0.707)
    p = interval_comparison(parallelness, -0.707, 0.707)

    # Break the pursuit/evasion into nine cases, the cross product of the
    # quarry being [ahead, aside, or behind] us
    # and heading [parallel, perpendicular, or anti-parallel] to us.
    case f
    when 1
      case p
      when 1
        gen="ahead, parallel"
        tf = 1.8
      when 0
        gen="ahead, perpendicular"
        tf = 1.35
      when -1
        gen="ahead, anti-parallel"
        tf = 1.10
      end
    when 0
      case p
      when 1
        gen="aside, parallel"
        tf = 1.20
      when 0
        gen="aside, perpedicular"
        tf = 1.20
      when -1
        gen="aside, anti-parallel"
        tf = 1.20
      end
    when -1
      case p
      when 1
        gen="behind, parallel"
        tf = 1.20
      when 0
        gen="behind, perpendicular"
        tf = 1.20
      when -1
        gen="behind, anti-parallel"
        tf = 1.20
      end
    end

    return [gen, tf]
  end

  #=============================================================
  private

  def interval_comparison(x, lower_bound, upper_bound)
    return -1 if x < lower_bound
    return 1 if x > upper_bound
    return 0
  end
end
